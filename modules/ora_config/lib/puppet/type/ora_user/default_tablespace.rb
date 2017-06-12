newproperty(:default_tablespace) do
  include EasyType
  include EasyType::Validators::Name
  include Puppet_X::EnterpriseModules::Oracle::CreateOnly
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The user's default tablespace.
  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('DEFAULT_TABLESPACE').upcase
  end

  on_apply do
    "default tablespace #{resource[:default_tablespace]}"
  end
end
