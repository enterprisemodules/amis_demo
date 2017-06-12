require 'puppet_x/enterprisemodules/oracle/access'
require 'easy_type'
require 'puppet/type/ora_schema_definition/version'
require 'fileutils'

Puppet::Type.type(:ora_schema_definition).provide(:sqlplus) do
  include EasyType::Provider
  include EasyType::Template
  include EasyType::Helpers
  include Puppet_X::EnterpriseModules::Oracle::Access

  confine :exists => '/etc/ora_setting.yaml'

  desc 'Manage The schema definition'

  mk_resource_methods

  def self.prefetch(resources)
    resources.each do |name, resource|
      options = options_for(resource[:schema_name], resource[:password], sid_from(resource))
      destroy(resource) if resource[:reinstall] == :true
      if version_table_exists?(options)
        statement = template('ora_config/ora_schema_definition/index.sql.erb', binding)
        versions = sql(statement, options)
      else
        versions = []
      end
      resource.provider = if versions.empty?
                            new(:ensure => :absent)
                          else
                            map_raw_to_resource(versions.last)
                          end
      if resource[:ensure] == :latest
        # We need the sources here so
        resource.parameters[:source_path].process # fetch the files
        resource[:ensure] = resource.provider.latest_available_version
      end
      resource
    end
  end

  def self.version_table_exists?(options)
    statement = template('ora_config/ora_schema_definition/version_table_exists.sql.erb', binding)
    rows = sql(statement, options)
    !rows.empty?
  end

  def self.options_for(username, password, sid)
    options = { :sid => sid }
    options[:username] = username
    password = password.nil? ? username : password
    options[:password] = password
    options
  end

  def upgrade_to(version)
    copy_upgrade_scripts_to_tmp
    ensure_version_table
    scripts = scripts_for_upgrade(self.ensure, version)
    execute_scripts(scripts) do |script|
      sequence, application, version, description = parse_script_name(script)
      "insert into schema_version (id, application, version, description, installation_time) values ('#{sequence}', '#{application}', '#{version}', '#{description}', sysdate)"
    end
  end

  def downgrade_to(version)
    copy_downgrade_scripts_to_tmp
    ensure_version_table
    scripts = scripts_for_downgrade(self.ensure, version)
    execute_scripts(scripts) do |script|
      # rubocop: disable Lint/UselessAssignment
      sequence = parse_script_name(script)
      "delete from schema_version where lpad(id,4,'0')='<%= sequence -%>'"
    end
  end

  def self.destroy(resource)
    Puppet.info "#{resource.path}: deleting all schema information"
    options = options_for(resource[:schema_name], resource[:password], sid_from(resource))
    options[:parse] = false
    statement = template('ora_config/ora_schema_definition/drop.sql.erb', binding)
    sql(statement, options)
  end

  def latest_available_version
    last_upgrade_script = upgrade_scripts.last
    if last_upgrade_script
      _, _, version = parse_script_name(upgrade_scripts.last)
    else
      version = :latest
    end
    version
  end

  private

  def copy_upgrade_scripts_to_tmp
    Pathname.glob("#{upgrade_path_for(resource[:source_path])}*.*").each { |f| FileUtils.cp(f.to_s, '/tmp') }
  end

  def copy_downgrade_scripts_to_tmp
    Pathname.glob("#{downgrade_path_for(resource[:source_path])}*.*").each { |f| FileUtils.cp(f.to_s, '/tmp') }
  end

  def execute_scripts(scripts)
    statements = template('ora_config/ora_schema_definition/execute.sql.erb', binding)
    scripts.each do |script|
      statements << "REM\n"
      Puppet.info "#{resource.path}: Applying #{script}"
      statements << "PROMPT Executing file #{script}\n"
      statements << "REM\n"
      statements << File.read(script)
      statements << "\n;\n" # Add an extra as a safe guard for a script that doesn't have one.
      statements << "commit;\n"
      statements << "connect #{resource[:schema_name]}/#{resource[:password]}\n"
      statements << yield(script) << ";\n"
      statements << "commit;\n"
    end
    options = self.class.options_for(resource[:schema_name], resource[:password], sid_from(resource))
    options[:parse] = false
    FileUtils.cd(resource[:source_path]) do
      sql statements, options
    end
  end

  def scripts_for_upgrade(from, to)
    unloaded_scripts(upgrade_scripts.select { |s| required_for_upgrade?(s, from, to) }.sort!)
  end

  def scripts_for_downgrade(from, to)
    downgrade_scripts.select { |s| required_for_downgrade?(s, from, to) }.sort!.reverse!
  end

  def required_for_upgrade?(script_name, source_from, source_to)
    required_for?(script_name, source_from, source_to) { |version, from, to| version > from && version <= to }
  end

  def required_for_downgrade?(script_name, source_from, source_to)
    required_for?(script_name, source_from, source_to) { |version, from, to| version <= from && version > to }
  end

  def required_for?(script_name, from, to)
    _, _, version = parse_script_name(script_name)
    begin
      version_object = Version.new(version)
      yield(version_object, from, to)
    rescue ArgumentError => e
      fail "#{e.message}; Check file name format of #{script_name}."
    end
  end

  def parse_script_name(name)
    name.basename.to_s.scan(/^(\d{4}).*_(\D*).*_(\d+.\d+.\d+.*).*_(.*)\.sql$/).flatten
  end

  def unloaded_scripts(scripts)
    scripts.select do |script|
      id, = parse_script_name(script)
      !is_loaded?(id)
    end
  end

  def upgrade_scripts
    Pathname.glob("#{upgrade_path_for(resource[:source_path])}*.sql").sort
  end

  def downgrade_scripts
    Pathname.glob("#{downgrade_path_for(resource[:source_path])}*.sql").sort
  end

  def is_loaded?(id)
    options = self.class.options_for(resource[:schema_name], resource[:password], sid_from(resource))
    !sql("select * from schema_version where id=#{id}", options).empty?
  end

  def ensure_version_table
    options = self.class.options_for(resource[:schema_name], resource[:password], sid_from(resource))
    create_version_table(options) unless self.class.version_table_exists?(options)
  end

  def create_version_table(options)
    Puppet.info "#{resource.path}: Creating schema_versions table."
    options[:parse] = false
    statement = template('ora_config/ora_schema_definition/create_table_schema_version.sql.erb', binding)
    sql(statement, options)
  end

  def upgrade_path_for(source_path)
    paths = Dir.glob("#{source_path}/**/upgrades")
    fail "Only one upgrade directory allowed in source_pad. #{paths.count} found." if paths.count > 1
    fail "source_path #{resource[:source_path]} doesn't contain a upgrades folder" if paths.empty?
    "#{paths.first}/"
  end

  def downgrade_path_for(source_path)
    paths = Dir.glob("#{source_path}/**/downgrades")
    fail "Only one downgrade directory allowed in source_pad. #{paths.count} found." if paths.count > 1
    fail "source_path #{resource[:source_path]} doesn't contain a downgrades folder" if paths.empty?
    "#{paths.first}/"
  end
end
