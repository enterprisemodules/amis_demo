require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  desc <<-EOD
    The role name.
  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    sid = raw_resource.column_data('SID')
    role_name = raw_resource.column_data('ROLE').upcase
    "#{role_name}@#{sid}"
  end
end
