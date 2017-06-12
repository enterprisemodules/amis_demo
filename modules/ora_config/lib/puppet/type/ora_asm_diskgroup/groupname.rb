newparam(:groupname) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The diskgroup name.

    This is a required String parameter that is part of the title of the raw_resource.

        ora_asm_diskgroup { 'RECODG@+ASM1':
          ...
        }

    In this example, the `RECODG` is de diskgroup name. Diskgroup names will always be uppercased by Puppet.
    This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
    case string.

  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('NAME').upcase
  end
end
