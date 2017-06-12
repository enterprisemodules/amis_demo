newproperty(:sessions_per_user, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the sessions_per_user value in a profile.

    Number of concurrent multiple sessions allowed per user

    sessions_per_user <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          sessions_per_user         => 'UNLIMITED'
          ...
        }
  EOD
end
