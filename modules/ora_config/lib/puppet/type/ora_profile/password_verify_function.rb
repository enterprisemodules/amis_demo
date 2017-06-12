newproperty(:password_verify_function, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the password_verify_function value in a profile.

    Verify passwords for length, content, and complexity

    password_verify_function <function_name | NULL | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          password_verify_function  => 'NULL',
          ...
        }

  EOD
end
