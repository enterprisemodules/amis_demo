newparam(:asm_path) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The directory name.

    This is a required String parameter that is part of the title of the raw_resource.

        ora_asm_directory { '+DATA/DIR/SUBDIR@+ASM1':
          ...
          asm_path    => '+DATA/DIR/SUBDIR',
          ...
        }

    In this example, the `RECODG` is de diskgroup name. Diskgroup names will always be uppercased by Puppet.
    This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
    case string.

  EOD

  isnamevar

end
