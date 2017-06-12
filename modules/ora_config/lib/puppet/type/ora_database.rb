require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'easy_type/encryption'
require 'puppet/type/ora_setting'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/information'
require 'puppet_x/enterprisemodules/oracle/commands'
require 'puppet_x/enterprisemodules/oracle/ora_tab'
require 'puppet_x/enterprisemodules/oracle/directories'
require 'puppet_x/enterprisemodules/oracle/utilities'

Puppet::Type.newtype(:ora_database) do
  include EasyType
  include EasyType::Encryption
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::Directories
  include Puppet_X::EnterpriseModules::Oracle::Commands
  include Puppet_X::EnterpriseModules::Oracle::Information

  desc <<-EOD
    This resource allows you to manage an Oracle Database.

    This type allows you to create a database. In one of it's simplest form:

        ora_database{'oradb':
          ensure          => present,
          oracle_base     => '/opt/oracle',
          oracle_home     => '/opt/oracle/app/11.04',
          control_file    => 'reuse',
        }

    The `ora_database` type uses structured types for some of the parameters. Here is part of an example
    with some of these structured parameters filled in:

        ora_database{'bert':
          logfile_groups => [
              {file_name => 'test1.log', size => '10M'},
              {file_name => 'test2.log', size => '10M'},
            ],
          ...
          default_tablespace => {
            name      => 'USERS',
            datafile  => {
              file_name  => 'users.dbs',
              size       => '1G',
              reuse      =>  true,
            },
            extent_management => {
              type          => 'local',
              autoallocate  => true,
            }
          },
          ...
          datafiles       => [
            {file_name   => 'file1.dbs', size => '1G', reuse => true},
            {file_name   => 'file2.dbs', size => '1G', reuse => true},
          ],
          ...
          default_temporary_tablespace => {
            name      => 'TEMP',
            type      => 'bigfile',
            tempfile  => {
              file_name  => 'tmp.dbs',
              size       => '1G',
              reuse      =>  true,
              autoextend => {
                next    => '10K',
                maxsize => 'unlimited',
              }
            },
            extent_management => {
              type          => 'local',
              uniform_size  => '1G',
            },
          },
          ....
          undo_tablespace   => {
            name      => 'UNDOTBS',
            type      => 'bigfile',
            datafile  => {
              file_name  => 'undo.dbs',
              size       => '1G',
              reuse      =>  true,
            }
          },
          ....
          sysaux_datafiles => [
            {file_name   => 'sysaux1.dbs', size => '1G', reuse => true},
            {file_name   => 'sysaux2.dbs', size => '1G', reuse => true},
          ]

  EOD

  to_get_raw_resources do
    #
    # Check for all available SID's. Not all SID's need to be running
    #
    available_databases.collect do |db|
      if running_db?(db) || local_pdb?(db)
        base_command = <<-EOD
column log_mode format a13
column cdb format a3
column force_logging format a13
EOD
        command = if local_pdb?(db)
                     "select gvp.name, 'NA' as log_mode, null as force_logging from gv$pdbs gvp where gvp.name = \'#{db}\'"
                  else
                    "select gvd.name, gvd.log_mode, gvd.force_logging from gv$database gvd, gv$instance gvi where gvd.inst_id = gvi.inst_id and gvi.instance_name = \'#{db}\'"
                  end
        full_command = base_command + command
        entry = sql(full_command, :sid => db).first
        entry['STATE'] = :running
        entry
      else
        EasyType::Helpers::InstancesResults['SID', db, 'NAME', db, 'LOG_MODE', nil, 'STATE', :stopped, 'CDB', :disabled, 'FORCE_LOGGING', :disabled]
      end
    end
  end

  ensurable

  on_create do
    @dbname = cluster? ? instance_name : name
    add_settings_entry
    add_oratab_entry
    if contained_by
      fail 'archivelog cannot be specified for pluggable databases' if ['enabled','disabled'].include? archivelog
      self[:sys_password] = configuration_value_for(contained_by, 'password')
      self[:oracle_home] = configuration_value_for(contained_by, 'oracle_home')
      sql template('ora_config/ora_database/create_pdb.sql.erb', binding), :sid => contained_by
    else
      begin
        create_directories
        create_init_ora_file
        create_ora_pwd_file

        create_stage_1
        create_stage_2
        execute_stage_1
        execute_stage_2
        if cluster?
          register_database
          add_instances
          start_database
        end

      rescue => e
        if ! contained_by
          remove_directories
        end
        remove_oratab_entry
        remove_settings_entry
        fail "Error creating database #{name}, #{e.message}. Rolling back creation of database"
      end
    end
    nil
  end

  on_modify do
    nil # Allow properties to do their stuff
  end

  on_destroy do
    if contained_by
      sql template('ora_config/ora_database/destroy_pdb.sql.erb', binding), :sid => contained_by
    else
      @dbname = cluster? ? instance_name : name
      if cluster?
        remove_instance_registrations
        remove_database_registration
      end
      sql template('ora_config/ora_database/destroy.sql.erb', binding), :sid => name
      remove_directories
      remove_oratab_entry
    end
    remove_settings_entry
    nil
  end

  parameter :name
  property  :state
  parameter :system_password
  parameter :sys_password
  parameter :init_ora_content
  parameter :timeout
  parameter :control_file
  parameter :maxdatafiles
  parameter :maxinstances
  parameter :character_set
  parameter :national_character_set
  parameter :tablespace_type
  parameter :logfile
  parameter :logfile_groups
  parameter :maxlogfiles
  parameter :maxlogmembers
  parameter :maxloghistory
  property  :force_logging
  parameter :extent_management
  parameter :oracle_home
  parameter :oracle_base
  parameter :oracle_user
  parameter :install_group
  property  :autostart
  parameter :default_tablespace
  parameter :datafiles
  parameter :default_temporary_tablespace
  parameter :undo_tablespace
  parameter :sysaux_datafiles
  parameter :spfile_location
  parameter :timezone
  parameter :config_scripts
  parameter :options
  #
  # Stuff for container databases
  #
  parameter :container_database
  parameter :file_name_convert
  #
  # Stuff for pluggable databases
  #
  parameter :contained_by
  parameter :pdb_admin_user
  parameter :pdb_admin_password
  # When defining a RAC database, these become valuable
  #
  parameter :instances
  parameter :scan_name
  parameter :scan_port
  # -- end of attributes -- Leave this comment if you want to use the scaffolder
  property :archivelog

  private

  def self.cluster_database?(sid)
    sid =~ /^.*\d$/
  end

  def self.database_from_sid(sid)
    sid.chop
  end

  def self.available_databases
    sids = registered_sids
    sids.select { |sid| database_sid?(sid) || local_pdb?(sid) }
  end

  def self.running_db?(sid)
    `pgrep -f "^(ora|xe)_pmon_#{sid}$"` != ''
  end

  def add_settings_entry
    contained_by = self[:contained_by] # temporary shadow parameter
    if contained_by
      pluggable        = true
      container_domain = db_domain(contained_by)
      domain_name      = container_domain ? container_domain : ''
      oracle_home      = configuration_value_for(contained_by, 'oracle_home')
    else
      oracle_home  = self[:oracle_home]
      pluggable    = false
      domain_name  = ''
      contained_by = ''
    end
    #
    # We only allow username and password fro remote databases
    #
    connect_string = contained_by.empty? ? '' : "//#{Facter.value('hostname')}/#{name}.#{domain_name}"
    cdb = container_database == :enabled ? true : false
    default = num_default_database_sids > 1 ? false : true
    entry = Puppet::Type::Ora_setting.new(:name           => @dbname,
                                          :oracle_home    => oracle_home,
                                          :default        => default,
                                          :connect_string => connect_string,
                                          :pluggable      => pluggable,
                                          :cdb            => cdb,
                                          :contained_by   => contained_by)
    entry.add
  end

  def remove_settings_entry
    entry = Puppet::Type::Ora_setting.new(:name => name)
    entry.remove
  end

  def create_init_ora_file
    File.open(init_ora_file, 'w') do |file|
      file.write(init_ora_content)
      if cluster?
        write_cluster_parameters(file)
      else
        file.write("#\n")
        file.write("# Parameters inserted by Puppet ora_database\n")
        file.write("#\n")
      end
    end
    owned_by_oracle(init_ora_file)
    Puppet.debug "File #{init_ora_file} created with content"
  end

  def write_cluster_parameters(file)
    instance_names = instances.keys.sort # sort the keys for ruby 1.8.7 Hash ordering
    instance_names.each_index do |index|
      instance = instance_names[index]
      instance_no = index + 1
      file.write("#\n")
      file.write("# Parameters inserted by Puppet ora_database (RAC)\n")
      file.write("#\n")
      file.write("#{instance}.instance_number=#{instance_no}\n")
      file.write("#{instance}.thread=#{instance_no}\n")
      file.write("#{instance}.undo_tablespace=UNDOTBS#{instance_no}\n")
    end
  end

  def add_oratab_entry
    oratab = Puppet_X::EnterpriseModules::Oracle::OraTab.new
    oratab.ensure_entry(@dbname, oracle_home, autostart)
  end

  def remove_oratab_entry
    oratab = Puppet_X::EnterpriseModules::Oracle::OraTab.new
    oratab.remove_entry(@dbname, oracle_home, autostart)
  end

  def create_ora_pwd_file
    orapwd("file=#{oracle_home}/dbs/orapw#{@dbname} force=y password='#{sys_password}' entries=20", :sid => @dbname)
  end

  def create_stage_1
    content = template('ora_config/ora_database/create.sql.erb', binding)
    path = "#{admin_scripts_path}/create.sql"
    File.open(path, 'w') { |f| f.write(content) }
    owned_by_oracle(path)
  end

  def create_stage_2
    with_config_scripts do |script, content|
      path = "#{admin_scripts_path}/#{script}.sql"
      File.open(path, 'w') { |f| f.write(content) }
      owned_by_oracle(path)
    end
  end

  def start_database
    srvctl("start database -d #{name}", :sid => @dbname)
  end

  def register_database
    command = if spfile_location
                "add database -d #{name} -o #{oracle_home} -n #{name} -m #{name} -p #{spfile_location}/#{name}/spfile#{name}.ora "
              else
                "add database -d #{name} -o #{oracle_home} -n #{name} -m #{name} "
              end
    srvctl(command, :sid => @dbname)
  end

  def add_instances
    instances.each do |instance, node|
      srvctl("add instance -d #{name} -i #{instance} -n #{node}", :sid => @dbname)
    end
  end

  def disable_database
    srvctl("disable database -d #{name}", :sid => @dbname)
  end

  def remove_instance_registrations
    instances.each do |instance, _node|
      srvctl("remove instance -d #{name} -i #{instance}", :sid => @dbname)
    end
  end

  def remove_database_registration
    srvctl("remove database -d #{name}", :sid => @dbname)
  end

  def execute_stage_1
    #
    # The create script generates some error's. SO that is why we ignore the errors
    #
    sql("@#{admin_scripts_path}/create", :sid => @dbname, :timeout => 0, :failonsqlfail => false)
  end

  def execute_stage_2
    with_config_scripts do |script, _|
      sql("@#{admin_scripts_path}/#{script}", :sid => @dbname, :timeout => 0)
    end
  end

  def instance_name
    instances.keys.sort.first
  end

  def cluster?
    instances.count > 0
  end

  def hostname
    Facter.value('hostname')
  end

  def init_ora_file
    "#{oracle_home}/dbs/init#{@dbname}.ora"
  end

  def admin_scripts_path
    "#{oracle_base}/admin/#{name}/scripts"
  end

  def with_config_scripts
    config_scripts.each do |entry|
      script = entry.keys.first
      content = entry[script]
      yield(script, content)
    end
  end

  def asm_path?(path)
    path.include?('+') ? true : false
  end
end
