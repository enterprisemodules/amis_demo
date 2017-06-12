Wrapper defined type for installing patches. [DEPRECATED]

Please use[`ora_opatch`](TODO) to manage patches of your database software.

Here is an example on how to use this:

```puppet
ora_install::opatch{'19121551_db_patch':
  ensure                    => 'present',
  oracle_product_home       => hiera('oracle_home_dir'),
  patch_id                  => '19121551',
  patch_file                => 'p19121551_112040_Linux-x86-64.zip',
  user                      => hiera('oracle_os_user'),
  group                     => 'oinstall',
  download_dir              => hiera('oracle_download_dir'),
  ocmrf                     => true,
  require                   => Ora_install::Opatchupgrade['112000_opatch_upgrade_db'],
  puppet_download_mnt_point => hiera('oracle_source'),
}
```

This defined class is D
<%- include_attributes [
  :bundle_sub_folder,
  :bundle_sub_patch_id,
  :clusterware,
  :download_dir,
  :ensure,
  :group,
  :ocmrf,
  :oracle_product_home,
  :patch_file,
  :patch_id,
  :puppet_download_mnt_point,
  :remote_file,
  :user
]%>
