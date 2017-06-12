newproperty(:connect_time, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the connect_time value in a profile.

    Allowable connect time per session in minutes

    connect_time <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          connect_time              => 'UNLIMITED',
          ...
        }

  EOD
end
