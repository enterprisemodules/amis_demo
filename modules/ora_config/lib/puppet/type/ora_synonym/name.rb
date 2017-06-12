require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  desc 'The synonym name'

  isnamevar

  to_translate_to_resource do |raw_resource|
    sid = raw_resource.column_data('SID')
    synonym_name = raw_resource.column_data('SYNONYM_NAME').upcase
    owner = raw_resource.column_data('OWNER').upcase
    "#{owner}.#{synonym_name}@#{sid}"
  end
end
