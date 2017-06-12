newproperty(:lb_advisory) do
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty

  desc <<-EOD
    Goal for the Load Balancing Advisory.

    Here is an example on how to use this:

        ora_service{'my_service':
          ...
          lb_advisory => 'THROUGHPUT',
          ...
        }

    Puppet provides no default value. But Oracle might, depending on your version.

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'Runtime Load Balancing Goal'
  newvalues(:NONE, :SERVICE_TIME, :THROUGHPUT, :none, :service_time, :throughput)
end
