newproperty(:failover_method) do
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty

  desc <<-EOD
    Failover method for the services.

    Here is an exaple on how to use this:

        ora_service{'my_service':
          ...
          failover_method => 'BASIC',
          ...
        }

    Puppet provides no default value. But Oracle might, depending on your version.

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'Failover method'
  newvalues(:NONE, :BASIC, :none, :basic)
end
