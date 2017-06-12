# encoding: UTF-8
newparam(:diskgroup) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::String

  desc <<-EOD
    The diskgroup into which we will create the volume.

        ora_asm_volume { "recodg:my_volume@+ASM1":
          ...
        }


    In this example, the `RECODG` is de diskgroup name. Diskgroup names will always be uppercased by Puppet.
    This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
    case string.

  EOD
end
