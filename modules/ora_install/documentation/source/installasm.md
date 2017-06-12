Installs and configures Oracle grid.

This defined class supports the following versions of grid:
- 11.2.0.4
- 12.1.0.1
- 12.1.0.2

Here is an example on how to use this:

```puppet
ora_install::installasm{ 'db_linux-x64':
  version                   => hiera('db_version'),
  file                      => hiera('asm_file'),
  grid_type                 => 'HA_CONFIG',
  grid_base                 => hiera('grid_base_dir'),
  grid_home                 => hiera('grid_home_dir'),
  ora_inventory_dir         => hiera('oraInventory_dir'),
  user_base_dir             => '/home',
  user                      => hiera('grid_os_user'),
  group                     => 'asmdba',
  group_install             => 'oinstall',
  group_oper                => 'asmoper',
  group_asm                 => 'asmadmin',
  sys_asm_password          => 'Welcome01',
  asm_monitor_password      => 'Welcome01',
  asm_diskgroup             => 'DATA',
  disk_discovery_string     => "/nfs_client/asm*",
  disks                     => "/nfs_client/asm_sda_nfs_b1,/nfs_client/asm_sda_nfs_b2",
  # disk_discovery_string   => "ORCL:*",
  # disks                   => "ORCL:DISK1,ORCL:DISK2",
  disk_redundancy           => "EXTERNAL",
  download_dir              => hiera('oracle_download_dir'),
  remote_file               => false,
  puppet_download_mnt_point => hiera('oracle_source'),
}
```

<%- include_attributes [
  :asm_diskgroup,
  :asm_monitor_password,
  :cluster_name,
  :cluster_nodes,
  :disk_au_size,
  :disk_discovery_string,
  :disk_redundancy,
  :bash_profile,
  :disks,
  :download_dir,
  :file,
  :grid_base,
  :grid_home,
  :grid_type,
  :group,
  :group_asm,
  :group_install,
  :group_oper,
  :network_interface_list,
  :ora_inventory_dir,
  :puppet_download_mnt_point,
  :remote_file,
  :scan_name,
  :scan_port,
  :stand_alone,
  :storage_option,
  :sys_asm_password,
  :temp_dir,
  :user,
  :user_base_dir,
  :version,
  :zip_extract
]%>
