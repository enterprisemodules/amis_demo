newproperty(:oracle_home) do
  include EasyType::YamlProperty

  desc <<-EOD
    The ORACLE_HOME where sqlplus can be found.

    This is a required setting. Here is an example on how to use this:

        ora_setting { 'DB1':
          ...
          oracle_home        => '/opt/oracle/12.1.0.2/db',
          ...
        }

  EOD
end
