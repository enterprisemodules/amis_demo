Installs the Oracle client software.

Using this defined type you can install the Oracle client software on your system.

Here is an example on how to use it:

```puppet
ora_install::client{ '12.1.0.1_Linux-x86-64':
  version                   => '12.1.0.1',
  file                      => 'linuxamd64_12c_client.zip',
  oracle_base               => '/oracle',
  oracle_home               => '/oracle/product/12.1/client',
  user                      => 'oracle',
  group                     => 'dba',
  group_install             => 'oinstall',
  download_dir              => '/install',
  bash_profile              => true,
  remote_file               => true,
  puppet_download_mnt_point => "puppet:///modules/oradb/",
  logoutput                 => true,
}
```

### support for multiple versions

This defined type has support for installing different versions of the client software on your system. In order to do this use the defined type multiple times in you manifest and use a different `oracle_home` and a different `file`.

<%- include_attributes [
  :bash_profile,
  :db_port,
  :download_dir,
  :file,
  :group,
  :group_install,
  :logoutput,
  :oracle_base,
  :oracle_home,
  :puppet_download_mnt_point,
  :remote_file,
  :temp_dir,
  :user,
  :user_base_dir,
  :version
]%>
