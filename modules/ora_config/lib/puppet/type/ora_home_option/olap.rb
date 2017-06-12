require 'puppet_x/enterprisemodules/oracle/settings'

newproperty(:olap) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Settings

  desc <<-EOD

      This resource allows you to manage(enable/disable) the OLAP option in an Oracle database home.

          ora_home_option { '/u01/app/oracle/product/12.1.0/db_home1':
            ...
            olap                     => 'enabled',
            ...
          }

  EOD

  newvalues(:disabled, :enabled)

  to_translate_to_resource do |raw_resource|
    raw_resource['OLAP']
  end

  on_modify do
    flag = enabled? ? 'enable' : 'disable'
    oh_settings_entry = configuration.select { |db, settings| settings['oracle_home'] == resource.name }.first
    os_user = configuration_value_for(oh_settings_entry.first, 'os_user')
    command = "su - #{os_user} -c \"export ORACLE_HOME=#{resource.name}; #{resource.name}/bin/chopt #{flag} olap\""
    options = { :failonfail => true, :combine => true }
    Puppet::Util::Execution.execute(command, options)
  end

  private

  def enabled?
    value == :enabled
  end

end
