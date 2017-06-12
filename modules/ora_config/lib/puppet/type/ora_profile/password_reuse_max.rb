newproperty(:password_reuse_max, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the password_reuse_max value in a profile.
    The number of times a password must be changed before it can be reused

    password_reuse_max <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          password_reuse_max        => 'UNLIMITED',
          ...
        }
  EOD
end
