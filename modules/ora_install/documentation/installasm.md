---
title: installasm
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

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




## Attributes



Attribute Name                                                     | Short Description                                                   |
------------------------------------------------------------------ | ------------------------------------------------------------------- |
[asm_diskgroup](#installasm_asm_diskgroup)                         | The name of the ASM diskgroup to use.                               |
[asm_monitor_password](#installasm_asm_monitor_password)           | The password for the ASM monitor.                                   |
[bash_profile](#installasm_bash_profile)                           | Create a bash profile for the specified user or not.                |
[cluster_name](#installasm_cluster_name)                           | The name of the cluster.                                            |
[cluster_nodes](#installasm_cluster_nodes)                         | The names of the nodes in the RAC cluster.                          |
[disk_au_size](#installasm_disk_au_size)                           | The disk_au size to use for the ASM disks.                          |
[disk_discovery_string](#installasm_disk_discovery_string)         | The search string to use for discovering disks for ASM.             |
[disk_redundancy](#installasm_disk_redundancy)                     | The type of redundancy to use.                                      |
[disks](#installasm_disks)                                         | List of disks to create a ASM DiskGroup.                            |
[download_dir](#installasm_download_dir)                           | The directory where the Puppet software puts all downloaded files.  |
[file](#installasm_file)                                           | The source file to use.                                             |
[grid_base](#installasm_grid_base)                                 | The directory to use as grid base.                                  |
[grid_home](#installasm_grid_home)                                 | The directory to use as grid home.                                  |
[grid_type](#installasm_grid_type)                                 | The type of grid.                                                   |
[group](#installasm_group)                                         | The os group to use for these Oracle puppet definitions.            |
[group_asm](#installasm_group_asm)                                 | The OS group to use.                                                |
[group_install](#installasm_group_install)                         | The os group to use for installation.                               |
[group_oper](#installasm_group_oper)                               | The OS group to allow ASM oper operations.                          |
[network_interface_list](#installasm_network_interface_list)       | The list of interfaces to use for RAC.                              |
[ora_inventory_dir](#installasm_ora_inventory_dir)                 | The directory that contains the oracle inventory.                   |
[puppet_download_mnt_point](#installasm_puppet_download_mnt_point) | The base path of all remote files for the defined type or class.    |
[remote_file](#installasm_remote_file)                             | The specified source file is a remote file or not.                  |
[scan_name](#installasm_scan_name)                                 | The name to use for the SCAN service.                               |
[scan_port](#installasm_scan_port)                                 | The IP portnumber to use for the SCAN service.                      |
[stand_alone](#installasm_stand_alone)                             | Configuring Grid Infrastructure for a Stand-Alone Server.           |
[storage_option](#installasm_storage_option)                       | The type of storage to use.                                         |
[sys_asm_password](#installasm_sys_asm_password)                   | The password to use for the SYSASM user.                            |
[temp_dir](#installasm_temp_dir)                                   | Directory to use for temporary files.                               |
[user](#installasm_user)                                           | The user used for the specified installation.                       |
[user_base_dir](#installasm_user_base_dir)                         | The directory to use as base directory for the users.               |
[version](#installasm_version)                                     | The version that is installed in the used Oracle home.              |
[zip_extract](#installasm_zip_extract)                             | The specified source file is a zip file that needs te be extracted. |




### asm_diskgroup<a name='installasm_asm_diskgroup'>

The name of the ASM diskgroup to use.

Default value is `DATA`

[Back to overview of installasm](#attributes)


### asm_monitor_password<a name='installasm_asm_monitor_password'>

The password for the ASM monitor.

[Back to overview of installasm](#attributes)


### cluster_name<a name='installasm_cluster_name'>

The name of the cluster.

[Back to overview of installasm](#attributes)


### cluster_nodes<a name='installasm_cluster_nodes'>

The names of the nodes in the RAC cluster.

Here is an example on how to use this:

```puppet
installasm{'asm12':
  ...
  cluster_nodes => ['db1', 'db2']
  ...
}
```

[Back to overview of installasm](#attributes)


### disk_au_size<a name='installasm_disk_au_size'>

The disk_au size to use for the ASM disks.

The default value is `1`.

[Back to overview of installasm](#attributes)


### disk_discovery_string<a name='installasm_disk_discovery_string'>

The search string to use for discovering disks for ASM.

[Back to overview of installasm](#attributes)


### disk_redundancy<a name='installasm_disk_redundancy'>

The type of redundancy to use.

Valid values are:
- NORMAL
- HIGH
- EXTERNAL

The default value is `NORMAL`.

[Back to overview of installasm](#attributes)


### bash_profile<a name='installasm_bash_profile'>

Create a bash profile for the specified user or not.

Valid values are `true` and `false`.

When you specify a `true` for the parameter, Puppet will create a standard bash profile for the specified user. The bash profile will be placed in a directory named `user_base_dir/user`.

```puppet
ora_install::client { 'Oracle client':
  ...
  bash_profile  => true,
  user          => 'oracle',
  user_base_dir => '/home',
  ...
}
```

This snippet will create a bash profile called `/home/oracle/.bash_profile`.

[Back to overview of installasm](#attributes)


### disks<a name='installasm_disks'>

List of disks to create a ASM DiskGroup.

[Back to overview of installasm](#attributes)


### download_dir<a name='installasm_download_dir'>

The directory where the Puppet software puts all downloaded files.

Before Puppet can actually use remote files, they must be downloaded first. Puppet uses this directory to put all files in.

The default value is `/install`

[Back to overview of installasm](#attributes)


### file<a name='installasm_file'>

The source file to use.

[Back to overview of installasm](#attributes)


### grid_base<a name='installasm_grid_base'>

The directory to use as grid base.

[Back to overview of installasm](#attributes)


### grid_home<a name='installasm_grid_home'>

The directory to use as grid home.

[Back to overview of installasm](#attributes)


### grid_type<a name='installasm_grid_type'>

The type of grid.

Valid values are:
- `HA_CONFIG`
- `CRS_CONFIG`
- `HA_CONFIG`
- `UPGRADE`
- `CRS_SWONLY`

The default value is `HA_CONFIG`

[Back to overview of installasm](#attributes)


### group<a name='installasm_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of installasm](#attributes)


### group_asm<a name='installasm_group_asm'>

The OS group to use.

The default value is `asmdba`.

[Back to overview of installasm](#attributes)


### group_install<a name='installasm_group_install'>

The os group to use for installation.

The default is `oinstall`

[Back to overview of installasm](#attributes)


### group_oper<a name='installasm_group_oper'>

The OS group to allow ASM oper operations.

The default value is `asmoper`.

[Back to overview of installasm](#attributes)


### network_interface_list<a name='installasm_network_interface_list'>

The list of interfaces to use for RAC.

The value should be a comma separated strings where each string is as shown below

```
InterfaceName:SubnetAddress:InterfaceType
```

where InterfaceType can be either "1", "2", or "3" (1 indicates public, 2 indicates private, and 3 indicates the interface is not used)

An example on how to use this:

```puppet
installasm{'asm12':
  ...
  network_interface_list => 'eth0:140.87.24.0:1,eth1:10.2.1.0:2,eth2:140.87.52.0:3'
  ...
}
```

[Back to overview of installasm](#attributes)


### ora_inventory_dir<a name='installasm_ora_inventory_dir'>

The directory that contains the oracle inventory.

The default value is: `oracle_base/oraInventory`.

[Back to overview of installasm](#attributes)


### puppet_download_mnt_point<a name='installasm_puppet_download_mnt_point'>

The base path of all remote files for the defined type or class.

The default value is `puppet:///modules/ora_install`.

[Back to overview of installasm](#attributes)


### remote_file<a name='installasm_remote_file'>

The specified source file is a remote file or not.

Default value is `true`.

[Back to overview of installasm](#attributes)


### scan_name<a name='installasm_scan_name'>

The name to use for the SCAN service.

[Back to overview of installasm](#attributes)


### scan_port<a name='installasm_scan_port'>

The IP portnumber to use for the SCAN service.

[Back to overview of installasm](#attributes)


### stand_alone<a name='installasm_stand_alone'>

Configuring Grid Infrastructure for a Stand-Alone Server.

The default value is `true`

[Back to overview of installasm](#attributes)


### storage_option<a name='installasm_storage_option'>

The type of storage to use.

Valid values are:
- ASM_STORAGE
- FILE_SYSTEM_STORAGE

[Back to overview of installasm](#attributes)


### sys_asm_password<a name='installasm_sys_asm_password'>

The password to use for the SYSASM user.

[Back to overview of installasm](#attributes)


### temp_dir<a name='installasm_temp_dir'>

Directory to use for temporary files.

[Back to overview of installasm](#attributes)


### user<a name='installasm_user'>

The user used for the specified installation.

The default value is `oracle`. The install class will not create the user for you. You must do that yourself.

Here is an example:

```puppet
ora_install::....{...
  ...
  user => 'my_oracle_user',
  ...
}
```

[Back to overview of installasm](#attributes)


### user_base_dir<a name='installasm_user_base_dir'>

The directory to use as base directory for the users.

[Back to overview of installasm](#attributes)


### version<a name='installasm_version'>

The version that is installed in the used Oracle home.

Puppet uses this value to decide on version specific actions.

[Back to overview of installasm](#attributes)


### zip_extract<a name='installasm_zip_extract'>

The specified source file is a zip file that needs te be extracted.

default value is `true`.

When you specify a value of false, the source attribute must contain a reference to a directory instead of a zip file. 

[Back to overview of installasm](#attributes)

