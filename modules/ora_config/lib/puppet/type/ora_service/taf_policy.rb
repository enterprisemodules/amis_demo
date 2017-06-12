newproperty(:taf_policy) do
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty

  desc <<-EOD
    Specfies the TAF policy specification (for administrator-managed databases only).

    Here is an example on how you can use this:

        ora_service { 'new_service':
          ...
          taf_policy => 'basic',
          ...
        }

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'TAF policy specification'
  newvalues(:BASIC, :NONE, :PRECONNECT, :basic, :none, :preconnect)

  on_apply do |_|
    "-P #{value}"
  end
end
