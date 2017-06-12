newproperty(:connect_string) do
  include EasyType::YamlProperty

  desc <<-EOD
  The connect string to use for the database.

  Here is an example:

      ora_setting { 'DB1':
        ...
        connect_string     => "//host1:1522/DB1",
        ...
      }

  EOD

  defaultto ''
end
