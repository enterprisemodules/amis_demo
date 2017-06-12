newproperty(:clb_goal) do
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty

  desc <<-EOD
    The load balancing goal to the service.

    Here is an exaple on how to use this:

        ora_service{'my_service':
          ...
          clb_goal => 'SHORT',
          ...
        }

    Puppet provides no default value. But Oracle might, depending on your version.

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  newvalues(:SHORT, :LONG, :short, :long)
  column_name 'Connection Load Balancing Goal'

end
