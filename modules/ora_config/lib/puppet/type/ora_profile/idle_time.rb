newproperty(:idle_time, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the idle_time value in a profile.

    Allowed idle time before user is disconnected (minutes)

    idle_time <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          idle_time                 => 'UNLIMITED',
          ...
        }

  EOD
end
