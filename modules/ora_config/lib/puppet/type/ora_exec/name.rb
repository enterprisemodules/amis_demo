require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  desc <<-EOD
    The full sql statement including a SID.

        ora_exec { 'select * from tab@sid':
          ...
        }

    The SID is optional. When you don't specify an SID, Puppet will take the first database instance
    from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
    name (e.g. a name including the SID).

  EOD

  isnamevar
end
