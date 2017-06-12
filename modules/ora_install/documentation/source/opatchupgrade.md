Installs or upgrades the specified version of the Oracle OPatch utility.

For `opatchupgrade` you need to provide the Oracle support csi_number and supportId and need to be online. Or leave them empty but it needs the Expect rpm to emulate OCM.

Here is an example on how to use this:

```puppet
ora_install::opatchupgrade{'112000_opatch_upgrade':
  oracle_home               => '/oracle/product/11.2/db',
  patch_file                => 'p6880880_112000_Linux-x86-64.zip',
  csi_number                => '11111',
  support_id                => 'john.doe@gmail.com',
  csi_number                => undef,
  support_id                => undef,
  opversion                 => '11.2.0.3.6',
  user                      => 'oracle',
  group                     => 'dba',
  download_dir              => '/install',
  puppet_download_mnt_point => $puppet_download_mnt_point,
}
```

<%- include_attributes [
  :csi_number,
  :download_dir,
  :group,
  :opversion,
  :oracle_home,
  :patch_file,
  :puppet_download_mnt_point,
  :support_id,
  :user
]%>
