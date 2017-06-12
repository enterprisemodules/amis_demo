require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  desc <<-EOD

  The full package name including a SID.

      ora_package { 'owner.my_package@sid':
        ...
      }

  The SID is optional. When you don't specify an SID, Puppet will take the first database instance
  from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
  name (e.g. a name including the SID).

  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    sid = raw_resource.column_data('SID')
    owner = raw_resource.column_data('OWNER').upcase
    package_name = raw_resource.column_data('NAME').upcase
    "#{owner}.#{package_name}@#{sid}"
  end
end
