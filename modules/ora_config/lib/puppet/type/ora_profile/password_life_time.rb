newproperty(:password_life_time, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the password_life_time value in a profile.

    The number of days the same password can be used for authentication

    password_life_time <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          password_life_time        => '180',
          ...
        }

  EOD
end
