newparam(:username) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The Oracle username the command will run in.

    If none is specified, it will run as `sysdba`.

        ora_exec { ...:
          ...
          username => 'scott',
        }

    EOD
end
