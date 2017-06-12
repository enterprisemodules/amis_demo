newproperty(:failover_type) do
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty

  desc <<-EOD
    Failover type.

    Here is an example on how to use this:

        ora_service{'my_service':
          ...
          failover_type => 'SESSION',
          ...
        }

    Puppet provides no default value. But Oracle might, depending on your version.

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'Failover type'
  newvalues(:NONE, :SESSION, :SELECT, :none, :session, :select)
end
