require 'puppet_x/enterprisemodules/oracle/settings'

newproperty(:direct_nfs) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Settings

  desc <<-EOD

      This resource allows you to manage(enable/disable) the DirectNFS option in an Oracle database home.

          ora_home_option { '/u01/app/oracle/product/12.1.0/db_home1':
            ...
            direct_nfs               => 'enabled',
            ...
          }

  EOD

  newvalues(:disabled, :enabled)

  to_translate_to_resource do |raw_resource|
    raw_resource['DNFS']
  end

  on_modify do
    flag = enabled? ? 'dnfs_on' : 'dnfs_off'
    oh_settings_entry = configuration.select { |db, settings| settings['oracle_home'] == resource.name }.first
    os_user = configuration_value_for(oh_settings_entry.first, 'os_user')
    command = "su - #{os_user} -c \"export ORACLE_HOME=#{resource.name}; cd #{resource.name}/rdbms/lib; make -f ins_rdbms.mk #{flag}\""
    options = { :failonfail => true, :combine => true }
    Puppet::Util::Execution.execute(command, options)
  end

  private

  def enabled?
    value == :enabled
  end

end
