newproperty(:password_grace_time, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the password_grace_time value in a profile.

    The number of days after the grace period begins during which a
    warning is issued and login is allowed. If the password is not
    changed during the grace period, the password expires.

    password_gracetime <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          password_grace_time       => '7',
          ...
        }
  EOD
end
