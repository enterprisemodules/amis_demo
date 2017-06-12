newproperty(:profile) do
  include EasyType
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::CreateOnly

  desc "The user's profile"

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('PROFILE').upcase
  end

  on_apply do
    "profile #{resource[:profile]}"
  end
end
