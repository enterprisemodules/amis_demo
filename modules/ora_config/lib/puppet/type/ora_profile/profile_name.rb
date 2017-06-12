newparam(:profile_name) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc 'The profile name'

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('PROFILE').upcase
  end
end
