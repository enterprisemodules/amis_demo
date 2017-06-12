require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  desc 'The profile name'

  isnamevar

  to_translate_to_resource do |raw_resource|
    sid = raw_resource.column_data('SID')
    name = raw_resource.column_data('PROFILE').upcase
    "#{name}@#{sid}"
  end
end
