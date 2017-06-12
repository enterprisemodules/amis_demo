newparam(:username) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The user name.
  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('USERNAME').upcase
  end
end
