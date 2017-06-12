You can use this class to install a working oracle database on your system.

This defined type supports the following versions of Oracle:
- 11.2.0.1
- 11.2.0.3
- 11.2.0.4
- 12.1.0.1
- 12.1.0.2

## Example

Here is an example on how you can use this class to install an Oracle database
on your system.

```puppet
ora_install::installdb{ '12.1.0.2_Linux-x86-64':
  version                   => '12.1.0.2',
  file                      => 'V46095-01',
  database_type             => 'SE',
  oracle_base               => '/oracle',
  oracle_home               => '/oracle/product/12.1/db',
  bash_profile              => true,
  user                      => 'oracle',
  group                     => 'dba',
  group_install             => 'oinstall',
  group_oper                => 'oper',
  download_dir              => '/data/install',
  zip_extract               => true,
  puppet_download_mnt_point => $puppet_download_mnt_point,
}
```


<%- include_attributes [
  :database_type,
  :download_dir,
  :bash_profile,
  :cleanup_install_files,
  :cluster_nodes,
  :create_user,
  :ee_optional_components,
  :ee_options_selection,
  :file,
  :group,
  :group_install,
  :group_oper,
  :is_rack_one_install,
  :ora_inventory_dir,
  :oracle_base,
  :oracle_home,
  :puppet_download_mnt_point,
  :remote_file,
  :temp_dir,
  :user,
  :user_base_dir,
  :version,
  :zip_extract,
] %>
