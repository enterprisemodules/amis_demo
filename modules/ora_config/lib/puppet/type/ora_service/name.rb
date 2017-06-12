require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  isnamevar

  to_translate_to_resource do |raw_resource|
    sid = raw_resource.column_data('SID')
    service_name = raw_resource.column_data('NAME').upcase
    "#{service_name}@#{sid}"
  end
end
