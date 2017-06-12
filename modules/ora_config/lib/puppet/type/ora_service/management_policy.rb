newproperty(:management_policy) do
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty

  desc <<-EOD
    Service management policy.

    Here is an example on how to use this:

        ora_service{'my_service':
          ...
          management_policy => 'AUTOMATIC',
          ...
        }

    Puppet provides no default value. But Oracle might, depending on your version.

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD
  column_name 'Management policy'
  newvalues(:AUTOMATIC, :MANUAL, :automatic, :manual)
end
