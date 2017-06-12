newproperty(:password) do
  include EasyType::EncryptedYamlProperty

  desc <<-EOD
    The password to use for database `sys` operations. This value is required when the database is not local. E.g the
    database is running on a remote server and is connected to through a remote connection string.

    Here is an example on how to use this:

    ora_setting { 'DB1':
      ...
      user               => 'sys',
      password           => 'password',
      ...
    }


  EOD

end
