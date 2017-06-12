newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  desc <<-EOD
    The object and name combination you want to manage. Including an appended SID.

        ora_object_audit { 'sys.dbms_aqin@SID':
          ...
        }

    The SID is optional. When you don't specify an SID, Puppet will take the first ASM instance
    from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
    name (e.g. a name including the SID).

  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    sid         = raw_resource.column_data('SID')
    object_name = raw_resource.column_data('OBJECT_NAME').upcase
    owner       = raw_resource.column_data('OWNER').upcase
    "#{owner}.#{object_name}@#{sid}"
  end
end
