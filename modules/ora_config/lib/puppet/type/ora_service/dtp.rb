newproperty(:dtp) do
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty

  desc <<-EOD
    Distributed Transaction Processing settings for this service.

    Here is an exaple on how to use this:

        ora_service{'my_service':
          ...
          dtp => false,
          ...
        }

    Puppet provides no default value. But Oracle might, depending on your version.

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'DTP transaction'
  newvalues(:true, :false)
end
