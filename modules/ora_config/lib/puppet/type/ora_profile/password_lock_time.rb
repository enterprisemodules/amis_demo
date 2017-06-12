newproperty(:password_lock_time, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the password_lock_time value in a profile.

    the number of days an account will be locked after the specified
    number of consecutive failed login attempts defined by
    FAILED_LOGIN_ATTEMPTS

    password_lock_time <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          password_lock_time        => '1',
          ...
        }

  EOD
end
