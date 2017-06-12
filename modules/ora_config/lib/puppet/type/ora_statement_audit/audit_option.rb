require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:audit_option) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The audit option you want to enable or disable.

    This is the first part of the full name. In this example:

        ora_audit { 'alter user@sid':
          ...
        }

    the `audit_option` is `alter_user`

  EOD

  isnamevar

end
