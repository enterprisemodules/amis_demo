Install the repository for several Oracle Fusion products.

## Creating a repository

Using this defined class, you can create repositories for several Oracle products. Here are some examples.

Here is an example on how to use it:

### SOA suite repository

```puppet
oradb::rcu{'DEV_PS6':
  rcu_file       => 'ofm_rcu_linux_11.1.1.7.0_32_disk1_1of1.zip',
  product        => 'soasuite',
  version        => '11.1.1.7',
  oracle_home    => '/oracle/product/11.2/db',
  user           => 'oracle',
  group          => 'dba',
  download_dir   => '/install',
  action         => 'create',
  db_server      => 'dbagent1.alfa.local:1521',
  db_service     => 'test.oracle.com',
  sys_password   => 'Welcome01',
  schema_prefix  => 'DEV',
  repos_password => 'Welcome02',
}
```

### webcenter repository

```puppet
oradb::rcu{'DEV2_PS6':
  rcu_file          => 'ofm_rcu_linux_11.1.1.7.0_32_disk1_1of1.zip',
  product           => 'webcenter',
  version           => '11.1.1.7',
  oracle_home       => '/oracle/product/11.2/db',
  user              => 'oracle',
  group             => 'dba',
  download_dir      => '/install',
  action            => 'create',
  db_server         => 'dbagent1.alfa.local:1521',
  db_service        => 'test.oracle.com',
  sys_password      => 'Welcome01',
  schema_prefix     => 'DEV',
  temp_tablespace   => 'TEMP',
  repos_password    => 'Welcome02',
}
```

### OIM, OAM repository

OIM needs an Oracle Enterprise Edition database

```puppet
oradb::rcu{'DEV_1112':
  rcu_file                  => 'V37476-01.zip',
  product                   => 'oim',
  version                   => '11.1.2.1',
  oracle_home               => '/oracle/product/11.2/db',
  user                      => 'oracle',
  group                     => 'dba',
  download_dir              => '/data/install',
  action                    => 'create',
  db_server                 => 'oimdb.alfa.local:1521',
  db_service                => 'oim.oracle.com',
  sys_password              => hiera('database_test_sys_password'),
  schema_prefix             => 'DEV',
  repos_password            => hiera('database_test_rcu_dev_password'),
  puppet_download_mnt_point => $puppet_download_mnt_point,
  logoutput                 => true,
  require                   => Oradb::Dbactions['start oimDb'],
 }
```

## deleting a repository

You can also use this defined type to delete a repository. To do so, you need te specify `delete` as action.

Here is an example:

```puppet
oradb::rcu{'Delete_DEV3_PS5':
  rcu_file          => 'ofm_rcu_linux_11.1.1.6.0_disk1_1of1.zip',
  product           => 'soasuite',
  version           => '11.1.1.6',
  oracle_home       => '/oracle/product/11.2/db',
  user              => 'oracle',
  group             => 'dba',
  download_dir      => '/install',
  action            => 'delete',
  db_server         => 'dbagent1.alfa.local:1521',
  db_service        => 'test.oracle.com',
  sys_password      => 'Welcome01',
  schema_prefix     => 'DEV3',
  repos_password    => 'Welcome02',
}
```

<%- include_attributes [
  :action,
  :db_server,
  :db_service,
  :download_dir,
  :group,
  :logoutput,
  :oracle_home,
  :product,
  :puppet_download_mnt_point,
  :rcu_file,
  :remote_file,
  :repos_password,
  :schema_prefix,
  :sys_password,
  :sys_user,
  :temp_tablespace,
  :user,
  :version
]%>
