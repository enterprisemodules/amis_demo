require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include EasyType
  include EasyType::Mungers::Upcase
  include EasyType::Validators::Name

  desc <<-EOD
    The database name.
  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('NAME')
  end
end
