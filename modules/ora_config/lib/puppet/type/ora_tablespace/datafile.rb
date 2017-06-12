newparam(:datafile) do
  include EasyType
  desc <<-EOD
    The name of the datafile.
  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('FILE_NAME')
  end
end
