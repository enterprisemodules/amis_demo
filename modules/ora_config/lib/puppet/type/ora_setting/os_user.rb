newproperty(:os_user) do
  include EasyType::YamlProperty

  desc <<-EOD
  The os username to use for local Database operations
  The database username to use for database sysdba operations. This value is required when the database is not local. E.g the
  database is running on a remote server and is connected to through a remote connection string.

  Here is an example on how to use this:

      ora_setting { 'DB1':
        ...
        os_user => 'oracle',
        ...
      }

  When you don't specify a value, Puppet takes the value `oracle` as default for
  regular databases. For ASM databases, it uses the value `grid`,

  EOD

  defaultto do
    resource[:name] =~ /\+ASM/ ? 'grid' : 'oracle'
  end
end
