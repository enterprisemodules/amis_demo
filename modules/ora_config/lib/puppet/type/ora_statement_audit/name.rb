require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  desc <<-EOD
    The audit type including a SID.

        ora_audit { 'alter user@sid':
          ...
        }

    The SID is optional. When you don't specify an SID, Puppet will take the first database instance
    from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
    name (e.g. a name including the SID).

  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    sid = raw_resource.column_data('SID')
    audit_type = raw_resource.column_data('AUDIT_OPTION').upcase
    "#{audit_type}@#{sid}"
  end
end
