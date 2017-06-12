newproperty(:failed_login_attempts, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the failed_login_attempts value in a profile.

    The number of failed attempts to log in to the user account before the account is locked

    failed_login_attempts <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          failed_login_attempts     => '10',
          ...
        }

  EOD
end
