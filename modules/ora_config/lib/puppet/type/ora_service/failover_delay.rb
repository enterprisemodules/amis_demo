newproperty(:failover_delay) do
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty
  include EasyType::Validators::Integer
  include EasyType::Mungers::Integer

  desc <<-EOD
    For Application Continuity and TAF, when reconnecting after a failure, delay between each connection retry (in seconds).

    Here is an exaple on how to use this:

        ora_service{'my_service':
          ...
          failover_delay => 10,
          ...
        }

    Puppet provides no default value. But Oracle might, depending on your version.

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'TAF failover delay'
end
