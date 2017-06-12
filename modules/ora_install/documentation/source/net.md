Installs and configures Oracle SQL*Net

This defined type allows you to install and configure Oracle SQL*net.

```puppet
ora_install::net{ 'config net8':
  oracle_home   => '/oracle/product/11.2/db',
  version       => '11.2',
  user          => 'oracle',
  group         => 'dba',
  download_dir  => '/install',
  db_port       => '1521', #optional
}
```

<%- include_attributes [
  :db_port,
  :download_dir,
  :group,
  :oracle_home,
  :user,
  :version
]%>
