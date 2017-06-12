Installs the Oracle Enterprise Manager Agent.

Here is an example:

```puppet
ora_install::installem{ 'em12104':
  version                     => '12.1.0.4',
  file                        => 'em12104_linux64',
  oracle_base_dir             => '/oracle',
  oracle_home_dir             => '/oracle/product/12.1/em',
  agent_base_dir              => '/oracle/product/12.1/agent',
  software_library_dir        => '/oracle/product/12.1/swlib',
  weblogic_user               => 'weblogic',
  weblogic_password           => 'Welcome01',
  database_hostname           => 'emdb.example.com',
  database_listener_port      => 1521,
  database_service_sid_name   => 'emrepos.example.com',
  database_sys_password       => 'Welcome01',
  sysman_password             => 'Welcome01',
  agent_registration_password => 'Welcome01',
  deployment_size             => 'SMALL',
  user                        => 'oracle',
  group                       => 'oinstall',
  download_dir                => '/install',
  zip_extract                 => true,
  puppet_download_mnt_point   => '/software',
  remote_file                 => false,
  log_output                  => true,
}
```

<%- include_attributes [
  :agent_base_dir,
  :agent_instance_home_dir,
  :agent_port,
  :agent_registration_password,
  :download_dir,
  :em_upload_port,
  :group,
  :install_platform,
  :install_type,
  :install_version,
  :log_output,
  :oms_host,
  :oms_port,
  :ora_inventory_dir,
  :oracle_base_dir,
  :source,
  :sysman_password,
  :sysman_user,
  :user,
  :version
]%>
