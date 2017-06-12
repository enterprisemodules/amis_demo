newproperty(:logical_reads_per_session, :parent => Puppet::Parameter::OracleProfileProperty) do
  desc <<-EOD
    Allows you set the logical_reads_per_session value in a profile.

    Maximum number of database blocks read per session

    logical_reads_per_session <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          logical_reads_per_session => 'UNLIMITED',
          ...
        }
  EOD
end
