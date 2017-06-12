require 'easy_type'

Puppet::Type.type(:ora_opatch).provide(:base) do
  include EasyType::Provider

  def os_user
    @os_user ||= self.class.user_for_file(oracle_product_home_dir)
  end

  desc 'Base provider for Oracle patches'

  mk_resource_methods

  confine :true => false # This is NEVER a valid provider. It is just used as a base class

  def self.prefetch(resources)
    orainst_dir = check_single_orainst_dir(resources)
    all_patches = oracle_homes(resources).collect { |h| patches_in_home(h, orainst_dir).collect { |p| p[:name] } }.flatten
    resources.keys.each do |patch_name|
      if all_patches.include?(patch_name)
        resources[patch_name].provider = new(:name => name, :ensure => :present)
      end
    end
  end

  def opatch(command, options)
    options = { :failonfail => true, :uid => os_user, :combine => true }.merge(options)
    Dir.chdir(oracle_product_home_dir) do
      full_command = "export ORACLE_HOME=#{oracle_product_home_dir}; #{oracle_product_home_dir}/OPatch/opatch #{command}"
      output = Puppet::Util::Execution.execute(full_command, options)
      Puppet.info output
      raise 'Opatch contained an error' unless output =~ /OPatch completed|OPatch succeeded|opatch auto succeeded|opatchauto succeeded/
      output
    end
  end

  def opatchauto(command, options)
    options = { :failonfail => true, :combine => true }.merge(options)
    Dir.chdir(oracle_product_home_dir) do
      full_command = "export ORACLE_HOME=#{oracle_product_home_dir}; #{oracle_product_home_dir}/OPatch/opatchauto #{command}"
      output = Puppet::Util::Execution.execute(full_command, options)
      Puppet.info output
      output
    end
  end

  [:patch_id, :oracle_product_home_dir, :orainst_dir, :source, :tmp_dir].each do |prop|
    define_method(prop) do
      resource[prop]
    end
  end

  private

  def self.user_for_file(home)
    #
    # To run opatch, we need the owner of the grid and oracle directory. The mechanism
    # we use to get this user, is to fetch the owner of the bin directory in the grid or
    # oracle home. Sometimes however, these directories also contain files with root as owner.
    # since root can never be the user of the grid or oracle processen, we skip those.
    #
    a_file = first_non_root_file(home)
    uid = File.stat("#{home}/#{a_file}").uid
    Etc.getpwuid(uid).name
  end

  def self.first_non_root_file(dir)
    Dir.new(dir).each { |file| break file if File.stat("#{dir}/#{file}").uid.nonzero? }
  end

  def self.patches_in_home(oracle_product_home_dir, orainst_dir)
    os_user = user_for_file(oracle_product_home_dir)
    Dir.chdir(oracle_product_home_dir) do
      full_command = "#{oracle_product_home_dir}/OPatch/opatch lspatches -oh #{oracle_product_home_dir} -invPtrLoc #{orainst_dir}/oraInst.loc"
      raw_list = Puppet::Util::Execution.execute(full_command, :failonfail => true, :uid => os_user)
      Puppet.info "\n#{raw_list}"
      raw_list.scan(/^(\d+);(.*)$/).collect { |e| { :name => "#{oracle_product_home_dir}:#{e[0]}", :comment => e[1] } }
    end
  end

  def self.check_single_orainst_dir(resources)
    orainst_dir = resources.map { |k, v| v.orainst_dir }.uniq
    raise "ora_opatch doesn't support multiple orainst_dir" if orainst_dir.size > 1
    orainst_dir.first
  end

  def self.oracle_homes(resources = nil)
    if resources
      resources.map { |k, v| v.oracle_product_home_dir }.uniq
    else
      oratab_content.scan(/^(?!#).*\:(.*)\:.*$/).flatten.uniq
    end
  end

  def self.installed_patches
    oracle_homes.collect do |oracle_home|
      patches_in_home(oracle_home, ora_invdir)
    end.flatten
  end

  def self.oratab_content
    File.read(oratab_file)
  end

  def self.oratab_file
    "#{ora_invdir}/oratab"
  end

  def self.ora_invdir
    os = Facter.value(:kernel)
    case os
    when 'Linux' then
      '/etc'
    when 'SunOS' then
      '/var/opt/oracle'
    else
      '/etc'
    end
  end
end
