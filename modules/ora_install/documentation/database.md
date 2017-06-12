---
title: database
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

This defined type allows you to create or delete a database.

 Under the hood the calls the `dbca` utility to do the work. When you need more control over the individual settings when creating the database, you must use the [`ora_database` custom type of the `ora_config` module](https://www.enterprisemodules.com/docs/ora_config/ora_database.html)

Here is an example on how to use this defined type to create a database:

```puppet
ora_install::database{ 'testDb_Create':
  action                    => 'create',
  oracle_base               => '/oracle',
  oracle_home               => '/oracle/product/11.2/db',
  version                   => '11.2',
  user                      => 'oracle',
  group                     => 'dba',
  download_dir              => '/install',
  action                    => 'create',
  db_name                   => 'test',
  db_domain                 => 'oracle.com',
  db_port                   => '1521',
  sys_password              => 'Welcome01',
  system_password           => 'Welcome01',
  data_file_destination     => "/oracle/oradata",
  recovery_area_destination => "/oracle/flash_recovery_area",
  character_set             => "AL32UTF8",
  nationalcharacter_set     => "UTF8",
  init_params               => {'open_cursors'        => '1000',
                              'processes'           => '600',
                              'job_queue_processes' => '4' },
  sample_schema             => 'TRUE',
  memory_percentage         => "40",
  memory_total              => "800",
  database_type             => "MULTIPURPOSE",
  em_configuration          => "NONE",
  require                   => Ora_install::Listener['start listener'],
}
```




## Attributes



Attribute Name                                                   | Short Description                                                  |
---------------------------------------------------------------- | ------------------------------------------------------------------ |
[action](#database_action)                                       | The action that must be taken.                                     |
[asm_diskgroup](#database_asm_diskgroup)                         | The ASM diskgroup to use for the database.                         |
[asm_snmp_password](#database_asm_snmp_password)                 | The password to use for the ASM SNMP service.                      |
[character_set](#database_character_set)                         | The character set to use for running the database.                 |
[cluster_nodes](#database_cluster_nodes)                         | The node name of the nodes running in the RAC cluster.             |
[container_database](#database_container_database)               | Database is a container for pluggable databases.                   |
[data_file_destination](#database_data_file_destination)         | The location of the data file's.                                   |
[database_type](#database_database_type)                         | The kind of database you want to create.                           |
[db_domain](#database_db_domain)                                 | The domain of the database.                                        |
[db_name](#database_db_name)                                     | The name of the database.                                          |
[db_port](#database_db_port)                                     | The IP port to use for the database.                               |
[db_snmp_password](#database_db_snmp_password)                   | Password to use for the snmp service.                              |
[download_dir](#database_download_dir)                           | The directory where the Puppet software puts all downloaded files. |
[em_configuration](#database_em_configuration)                   | The type of Enterprise Manager configuration.                      |
[group](#database_group)                                         | The os group to use for these Oracle puppet definitions.           |
[init_params](#database_init_params)                             | The init parameters to use for the database.                       |
[memory_percentage](#database_memory_percentage)                 | The percentage of physical memory for Oracle.                      |
[memory_total](#database_memory_total)                           | The total memory in MB to allocate to Oracle.                      |
[nationalcharacter_set](#database_nationalcharacter_set)         | Use this NLS Character set.                                        |
[oracle_base](#database_oracle_base)                             | A directory to use as Oracle base directory.                       |
[oracle_home](#database_oracle_home)                             | A directory to be used as Oracle home directory for this software. |
[puppet_download_mnt_point](#database_puppet_download_mnt_point) | The base path of all remote files for the defined type or class.   |
[recovery_area_destination](#database_recovery_area_destination) | Location of the recovary files.                                    |
[recovery_diskgroup](#database_recovery_diskgroup)               | Diskgroup to use for recovery files.                               |
[sample_schema](#database_sample_schema)                         | Load the sample schema or not.                                     |
[storage_type](#database_storage_type)                           | The storage type to use.                                           |
[sys_password](#database_sys_password)                           | The password to use for the `SYS` user.                            |
[system_password](#database_system_password)                     | The password to use for the `SYSTEM` user.                         |
[template](#database_template)                                   | Use the specified template to create the database.                 |
[user](#database_user)                                           | The user used for the specified installation.                      |
[version](#database_version)                                     | The version that is installed in the used Oracle home.             |




### action<a name='database_action'>

The action that must be taken. create or delete.

Valid values are:
- `create`
- `delete`

The default value is `create`

[Back to overview of database](#attributes)


### asm_diskgroup<a name='database_asm_diskgroup'>

The ASM diskgroup to use for the database.

The default value is `DATA`

[Back to overview of database](#attributes)


### asm_snmp_password<a name='database_asm_snmp_password'>

The password to use for the ASM SNMP service.

[Back to overview of database](#attributes)


### character_set<a name='database_character_set'>

The character set to use for running the database.

The default value is `AL32UTF8`.

[Back to overview of database](#attributes)


### cluster_nodes<a name='database_cluster_nodes'>

The node name of the nodes running in the RAC cluster.

[Back to overview of database](#attributes)


### container_database<a name='database_container_database'>

Database is a container for pluggable databases.

Default value is `false`. When you want to add pluggable database to this database, specify a value of `true`.

[Back to overview of database](#attributes)


### data_file_destination<a name='database_data_file_destination'>

The location of the data file's.

[Back to overview of database](#attributes)


### database_type<a name='database_database_type'>

The kind of database you want to create.

Valid values are:

- MULTIPURPOSE
- DATA_WAREHOUSING
- OLTP

Default value is `MULTIPURPOSE`

[Back to overview of database](#attributes)


### db_domain<a name='database_db_domain'>

The domain of the database.

[Back to overview of database](#attributes)


### db_name<a name='database_db_name'>

The name of the database.

[Back to overview of database](#attributes)


### db_port<a name='database_db_port'>

The IP port to use for the database.

Default value is `1521`

[Back to overview of database](#attributes)


### db_snmp_password<a name='database_db_snmp_password'>

Password to use for the snmp service.

[Back to overview of database](#attributes)


### download_dir<a name='database_download_dir'>

The directory where the Puppet software puts all downloaded files.

Before Puppet can actually use remote files, they must be downloaded first. Puppet uses this directory to put all files in.

The default value is `/install`

[Back to overview of database](#attributes)


### em_configuration<a name='database_em_configuration'>

The type of Enterprise Manager configuration.

Valid values are:

- `CENTRAL`
- `LOCAL`
- `ALL`
- `NONE`

Default value is `NONE`.

[Back to overview of database](#attributes)


### group<a name='database_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of database](#attributes)


### init_params<a name='database_init_params'>

The init parameters to use for the database.

You can use either a comma separated string for init_params or a Hash.

### Using comma separated string

Here is an example using a comma separated string:

``` puppet
ora_install::database{'my_database'
  ...
  init_params => "open_cursors=1000,processes=600,job_queue_processes=4",
  ...
}
```

### Using a Hash

Here is an example using a Hash:

``` puppet
ora_install::database{'my_database'
  ...
  init_params  => {'open_cursors'        => '1000',
                  'processes'           => '600',
                  'job_queue_processes' => '4' },
  }
  ...
}
```

[Back to overview of database](#attributes)


### memory_percentage<a name='database_memory_percentage'>

The percentage of physical memory for Oracle.

Default value is `40`.

[Back to overview of database](#attributes)


### memory_total<a name='database_memory_total'>

The total memory in MB to allocate to Oracle.

Default = `800`

[Back to overview of database](#attributes)


### nationalcharacter_set<a name='database_nationalcharacter_set'>

Use this NLS Character set.

Default value is `UTF8`

[Back to overview of database](#attributes)


### oracle_base<a name='database_oracle_base'>

A directory to use as Oracle base directory.

[Back to overview of database](#attributes)


### oracle_home<a name='database_oracle_home'>

A directory to be used as Oracle home directory for this software.

[Back to overview of database](#attributes)


### puppet_download_mnt_point<a name='database_puppet_download_mnt_point'>

The base path of all remote files for the defined type or class.

The default value is `puppet:///modules/ora_install`.

[Back to overview of database](#attributes)


### recovery_area_destination<a name='database_recovery_area_destination'>

Location of the recovary files.

[Back to overview of database](#attributes)


### recovery_diskgroup<a name='database_recovery_diskgroup'>

Diskgroup to use for recovery files.

[Back to overview of database](#attributes)


### sample_schema<a name='database_sample_schema'>

Load the sample schema or not.

Default value is `TRUE`. **Attention** This is a string and not a boolean value.

[Back to overview of database](#attributes)


### storage_type<a name='database_storage_type'>

The storage type to use.

Valid values are:
- `FS`
- `CFS`
- `ASM`

Default value is `FS`

[Back to overview of database](#attributes)


### sys_password<a name='database_sys_password'>

The password to use for the `SYS` user.

[Back to overview of database](#attributes)


### system_password<a name='database_system_password'>

The password to use for the `SYSTEM` user.

[Back to overview of database](#attributes)


### template<a name='database_template'>

Use the specified template to create the database.

You can choose between a set of pre-delivered templates, but also specify your own templates.

## Using a pre-delivered template

`ora_install` delivers a few predefined templates.
- dbtemplate_11GR2
- dbtemplate_12.1
- dbtemplate_12.1_asm

Here is an example on how to use this:

```puppet
ora_install::database{ 'testDb_Create':
  ...
  template                  => 'dbtemplate_12.1',
  ...
}
```

## Using your own template

When you specify a template name not pre-delivered by `ora_install`, the defined type will look in the directory specified by `puppet_download_mnt_point` for your own template.

Here is an example:

```puppet
  template                   => 'my_dbtemplate_11gR2_asm',
  puppet_download_mnt_point  => '/vagrant', # 'ora_install' etc
```

The template must be have the following extension dbt.erb like `dbtemplate_12.1.dbt.erb`

- Click here for an [12.1 db instance template example](https://github.com/enterprisemodules/ora_install/blob/master/templates/dbtemplate_12.1.dbt.erb)
- Click here for an [11.2 db asm instance template example](https://github.com/enterprisemodules/ora_install/blob/master/templates/dbtemplate_11gR2_asm.dbt.erb)

[Back to overview of database](#attributes)


### user<a name='database_user'>

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

[Back to overview of database](#attributes)


### version<a name='database_version'>

The version that is installed in the used Oracle home.

Puppet uses this value to decide on version specific actions.

[Back to overview of database](#attributes)

