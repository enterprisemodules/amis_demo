require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  desc <<-EOD
    The full diskgroup name including SID.

    The full diskgroup name contains a diskgroup and an SID.

        ora_asm_diskgroup { 'RECODG@+ASM1':
          ...
        }

    The SID is optional. When you don't specify an SID, Puppet will take the first ASM instance
    from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
    name (e.g. a name including the SID).

  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    asm_sid = raw_resource.column_data('SID')
    diskgroup_name = raw_resource.column_data('NAME').upcase
    "#{diskgroup_name}@#{asm_sid}"
  end
end
