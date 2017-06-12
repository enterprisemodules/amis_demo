require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:grantee) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The Oracle username that is granted (or revoked) the permission.

    This parameter is extracted from the title of the type. It is separated by the object by a `/`.

        ora_object_grant { 'SCOTT->sys.dbms_aqin@SID':
          ...
        }

    In this example `SCOTT` is the grantee. Grantee names will always be uppercased by Puppet.
    This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
    case string.

  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('GRANTEE').upcase
  end
end
