---
title: rcu
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

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




## Attributes



Attribute Name                                              | Short Description                                                  |
----------------------------------------------------------- | ------------------------------------------------------------------ |
[action](#rcu_action)                                       | The action to perform.                                             |
[db_server](#rcu_db_server)                                 | The name of the database server to use.                            |
[db_service](#rcu_db_service)                               | The name of the database service to use.                           |
[download_dir](#rcu_download_dir)                           | The directory where the Puppet software puts all downloaded files. |
[group](#rcu_group)                                         | The os group to use for these Oracle puppet definitions.           |
[logoutput](#rcu_logoutput)                                 | log the outputs of Puppet exec or not.                             |
[oracle_home](#rcu_oracle_home)                             | A directory to be used as Oracle home directory for this software. |
[product](#rcu_product)                                     | The name of the product for which you want to install the RCU.     |
[puppet_download_mnt_point](#rcu_puppet_download_mnt_point) | The base path of all remote files for the defined type or class.   |
[rcu_file](#rcu_rcu_file)                                   | The file containing the RCU definition.                            |
[remote_file](#rcu_remote_file)                             | The specified source file is a remote file or not.                 |
[repos_password](#rcu_repos_password)                       | The password for the repo user.                                    |
[schema_prefix](#rcu_schema_prefix)                         | The prefix name to use for the schema.                             |
[sys_password](#rcu_sys_password)                           | The password of the `SYS` user on the database.                    |
[sys_user](#rcu_sys_user)                                   | The name of the `SYS` user on the database.                        |
[temp_tablespace](#rcu_temp_tablespace)                     | Create a temporary tablespace with this name.                      |
[user](#rcu_user)                                           | The user used for the specified installation.                      |
[version](#rcu_version)                                     | The version that is installed in the used Oracle home.             |




### action<a name='rcu_action'>

The action to perform.

Valid actions are:
- `create`
- `delete`

The default action is `create`.

[Back to overview of rcu](#attributes)


### db_server<a name='rcu_db_server'>

The name of the database server to use.

[Back to overview of rcu](#attributes)


### db_service<a name='rcu_db_service'>

The name of the database service to use.

[Back to overview of rcu](#attributes)


### download_dir<a name='rcu_download_dir'>

The directory where the Puppet software puts all downloaded files.

Before Puppet can actually use remote files, they must be downloaded first. Puppet uses this directory to put all files in.

The default value is `/install`

[Back to overview of rcu](#attributes)


### group<a name='rcu_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of rcu](#attributes)


### logoutput<a name='rcu_logoutput'>

log the outputs of Puppet exec or not.

When you specify `true` Puppet will log all output of `exec` types.

[Back to overview of rcu](#attributes)


### oracle_home<a name='rcu_oracle_home'>

A directory to be used as Oracle home directory for this software.

[Back to overview of rcu](#attributes)


### product<a name='rcu_product'>

The name of the product for which you want to install the RCU.

The following strings are supported as product:
- soasuite
- webcenter
- all

[Back to overview of rcu](#attributes)


### puppet_download_mnt_point<a name='rcu_puppet_download_mnt_point'>

The base path of all remote files for the defined type or class.

The default value is `puppet:///modules/ora_install`.

[Back to overview of rcu](#attributes)


### rcu_file<a name='rcu_rcu_file'>

The file containing the RCU definition.

[Back to overview of rcu](#attributes)


### remote_file<a name='rcu_remote_file'>

The specified source file is a remote file or not.

Default value is `true`.

[Back to overview of rcu](#attributes)


### repos_password<a name='rcu_repos_password'>

The password for the repo user.

[Back to overview of rcu](#attributes)


### schema_prefix<a name='rcu_schema_prefix'>

The prefix name to use for the schema.

[Back to overview of rcu](#attributes)


### sys_password<a name='rcu_sys_password'>

The password of the `SYS` user on the database.

[Back to overview of rcu](#attributes)


### sys_user<a name='rcu_sys_user'>

The name of the `SYS` user on the database.

[Back to overview of rcu](#attributes)


### temp_tablespace<a name='rcu_temp_tablespace'>

Create a temporary tablespace with this name.

[Back to overview of rcu](#attributes)


### user<a name='rcu_user'>

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

[Back to overview of rcu](#attributes)


### version<a name='rcu_version'>

The version that is installed in the used Oracle home.

Puppet uses this value to decide on version specific actions.

[Back to overview of rcu](#attributes)

