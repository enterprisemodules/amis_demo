newproperty(:user) do
  include EasyType::YamlProperty

  desc <<-EOD
  The database username to use for database sysdba operations. This value is required when the database is not local. E.g the
  database is running on a remote server and is connected to through a remote connection string.

  Here is an example on how to use this:

      ora_setting { 'DB1':
        ...
        user               => 'sys',
        password           => 'password',
        ...
      }

  EOD
  defaultto 'sys'
end
