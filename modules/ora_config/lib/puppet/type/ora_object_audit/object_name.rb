newparam(:object_name) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The object name.

    This parameter is extracted from the title of the type. It is the first part of the name.

        ora_object_audit { 'sys.dbms_aqin@SID':
          ...
        }

    In this example `sys.dbms_aqin` is the object name. The object names will always be uppercased by Puppet.
    This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
    case string.

    You must specify full qualified object names. This means `owner.object`.

  EOD

  isnamevar

end
