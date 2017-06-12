newproperty(:logical_reads_per_call, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the logical_reads_per_call value in a profile.

    Maximum number of database blocks read per call

    logical_reads_per_call <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          logical_reads_per_call    => 'UNLIMITED',
          ...
        }

  EOD
end
