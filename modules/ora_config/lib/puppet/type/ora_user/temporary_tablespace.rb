newproperty(:temporary_tablespace) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::CreateOnly

  desc <<-EOD
    The user's temporary tablespace.
  EOD

  defaultto 'TEMP'

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('TEMPORARY_TABLESPACE').upcase
  end

  on_apply do
    "temporary tablespace #{resource[:temporary_tablespace]}"
  end
end
