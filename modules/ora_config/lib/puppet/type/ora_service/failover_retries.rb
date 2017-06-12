newproperty(:failover_retries) do
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty
  include EasyType::Validators::Integer
  include EasyType::Mungers::Integer

  desc <<-EOD
    The number of failover retry attempts.

    Here is an exaple on how to use this:

        ora_service{'my_service':
          ...
          failover_retries => 3,
          ...
        }

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'TAF failover retries'
end
