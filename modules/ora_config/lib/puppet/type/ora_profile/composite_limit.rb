newproperty(:composite_limit, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the composite_limit value in a profile.

    Maximum weighted sum of: CPU_PER_SESSION, CONNECT_TIME,
    LOGICAL_READS_PER_SESSION, and PRIVATE_SGA. If this limit is exceeded, Oracle aborts the session and returns an error.

    composite_limit <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ensure                    => 'present',
            ...
          composite_limit           => 'UNLIMITED',
            ...
        }

  EOD
end
