newproperty(:service_role) do
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty

  desc <<-EOD
    The service role for the specfied services.

    Here is an example on how to use this:

        ora_service{'my_service':
          ...
          service_role => 'PHYSICAL_STANDBY',
          ...
        }

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.


  EOD

  column_name 'Service role'
  newvalues(:PRIMARY, :PHYSICAL_STANDBY, :LOGICAL_STANDBY, :SNAPSHOT_STANDBY, :primary, :physical_standby, :logical_standby, :snapshot_standby)

end
