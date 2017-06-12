newproperty(:private_sga, :parent => Puppet::Parameter::OracleProfileProperty) do
  include EasyType::Mungers::Size

  desc <<-EOD
    Allows you set the private_sga value in a profile.

    Maximum integer bytes of private space in the SGA
    (useful for systems using multi-threaded server MTS)

    private_sga <value | UNLIMITED | DEFAULT>

    Here is an example on how to use this:

        ora_profile { 'DEFAULT@sid':
          ...
          private_sga               => 'UNLIMITED',
          ...
        }
  EOD
end
