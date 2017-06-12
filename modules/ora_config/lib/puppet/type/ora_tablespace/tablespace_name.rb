newparam(:tablespace_name) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The tablespace name.
  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('TABLESPACE_NAME')
  end
end
