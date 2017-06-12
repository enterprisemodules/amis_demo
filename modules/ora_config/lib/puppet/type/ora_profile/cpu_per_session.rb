newproperty(:cpu_per_session, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the cpu_per_session value in a profile.

    Maximum CPU time per session (100ths of a second)

    cpu_per_session <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          cpu_per_call              => 'UNLIMITED',
          ...
        }

  EOD
end
