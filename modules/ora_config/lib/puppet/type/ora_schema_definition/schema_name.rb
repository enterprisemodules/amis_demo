require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:schema_name) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  isnamevar

  desc <<-EOD
    The schema name.

    The schema name is part of the title of the resource. In this example:

        ora_schema_definition{'MYAPP@SID':
          ensure => latest,
          password => 'secret',
          ...
        }

    The schema name is the part of the title before the `@` character. In this case `MYAPP`.
    The puppet type uses this as the Oracle user to log in. Yo must specify the password in the
    resource definition.

  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('APPLICATION').upcase
  end
end
