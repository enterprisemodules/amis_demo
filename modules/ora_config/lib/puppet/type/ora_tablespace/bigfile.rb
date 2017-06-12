newproperty(:bigfile) do
  include EasyType

  desc <<-EOD
    Specify if you want a `bigfile` or a `smallfile` tablespace. 
  EOD

  newvalues(:yes, :no)

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('BIG').downcase.to_sym
  end
end
