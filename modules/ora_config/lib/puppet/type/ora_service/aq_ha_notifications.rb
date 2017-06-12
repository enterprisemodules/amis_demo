newproperty(:aq_ha_notifications) do
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty

  desc <<-EOD
    Indicates whether AQ HA notifications should be enabled.

    To enable FAN for OCI connections, set AQ HA Notifications to True. For Oracle Database 12c, FAN uses ONS (Oracle Notification Service).

    Here is an exaple on how to use this:

        ora_service{'my_service':
          ...
          aq_ha_notifications => false,
          ...
        }

    Puppet provides no default value. But Oracle might, depending on your version.

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'AQ HA notifications'
  newvalues(:true, :false)
end
