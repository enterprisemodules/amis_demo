# encoding: UTF-8
newparam(:volume_name) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::String

  desc <<-EOD
    The name of the volume to manage.

        ora_asm_volume { "recodg:my_volume@+ASM1":
          ...
        }

    In this example, the `my_colume` is de volume name. Volume names names will always be uppercased by Puppet.
    This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
    case string.

  EOD
end
