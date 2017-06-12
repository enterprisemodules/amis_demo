newparam(:role_name) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The role name.
  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('ROLE').upcase
  end
end
