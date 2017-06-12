require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:trigger_name) do
  include EasyType
  include EasyType::Mungers::Upcase
  include EasyType::Validators::Name

  desc <<-EOD
    The name of the triggeryou want to manage. The trigger name  is the second part of the
    title.

        ora_trigger { 'owner.trigger_name@sid':
          ...
        }

  EOD

  isnamevar
end
