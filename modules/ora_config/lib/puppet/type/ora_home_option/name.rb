newparam(:name) do
  include EasyType

  desc 'The name'

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource['NAME']
  end
end
