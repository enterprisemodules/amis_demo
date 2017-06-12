newproperty(:password_reuse_time, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the password_reuse_time value in a profile.

    The number of days between reuses of a password

    password_reuse_time <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          password_reuse_time       => 'UNLIMITED',
          ...
        }

  EOD
end
