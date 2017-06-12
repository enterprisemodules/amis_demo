newparam(:name) do
  include EasyType

  desc 'The name'

  isnamevar

  to_translate_to_resource do |raw_resource|
    sid = raw_resource['SID']
    name = raw_resource['OPTION']
    "#{name}@#{sid}"
  end
end
