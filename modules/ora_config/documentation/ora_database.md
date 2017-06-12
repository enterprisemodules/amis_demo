---
title: ora_database
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This resource allows you to manage an Oracle Database.

This type allows you to create a database. In one of it's simplest form:

    ora_database{'oradb':
      ensure          => present,
      oracle_base     => '/opt/oracle',
      oracle_home     => '/opt/oracle/app/11.04',
      control_file    => 'reuse',
    }

The `ora_database` type uses structured types for some of the parameters. Here is part of an example
with some of these structured parameters filled in:

    ora_database{'bert':
      logfile_groups => [
          {file_name => 'test1.log', size => '10M'},
          {file_name => 'test2.log', size => '10M'},
        ],
      ...
      default_tablespace => {
        name      => 'USERS',
        datafile  => {
          file_name  => 'users.dbs',
          size       => '1G',
          reuse      =>  true,
        },
        extent_management => {
          type          => 'local',
          autoallocate  => true,
        }
      },
      ...
      datafiles       => [
        {file_name   => 'file1.dbs', size => '1G', reuse => true},
        {file_name   => 'file2.dbs', size => '1G', reuse => true},
      ],
      ...
      default_temporary_tablespace => {
        name      => 'TEMP',
        type      => 'bigfile',
        tempfile  => {
          file_name  => 'tmp.dbs',
          size       => '1G',
          reuse      =>  true,
          autoextend => {
            next    => '10K',
            maxsize => 'unlimited',
          }
        },
        extent_management => {
          type          => 'local',
          uniform_size  => '1G',
        },
      },
      ....
      undo_tablespace   => {
        name      => 'UNDOTBS',
        type      => 'bigfile',
        datafile  => {
          file_name  => 'undo.dbs',
          size       => '1G',
          reuse      =>  true,
        }
      },
      ....
      sysaux_datafiles => [
        {file_name   => 'sysaux1.dbs', size => '1G', reuse => true},
        {file_name   => 'sysaux2.dbs', size => '1G', reuse => true},
      ]

## Attributes



Attribute Name                                                             | Short Description                                                                            |
-------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
[archivelog](#ora_database_archivelog)                                     | Enable or disable archive log.                                                               |
[autostart](#ora_database_autostart)                                       | Add autostart to the oratab entry.                                                           |
[character_set](#ora_database_character_set)                               | Specify the character set the database uses to store data.                                   |
[config_scripts](#ora_database_config_scripts)                             | environment after the initial database fileset has been created.                             |
[contained_by](#ora_database_contained_by)                                 | Specify the SID of the container database where the pluggable databases should be part of.   |
[container_database](#ora_database_container_database)                     | Enable or disable the containers and adding pluggable databases
                             |
[control_file](#ora_database_control_file)                                 | Specify reuse, to reuse existing control files.                                              |
[datafiles](#ora_database_datafiles)                                       | One or more files to be used as datafiles.                                                   |
[default_tablespace](#ora_database_default_tablespace)                     | Specify the default tablespace.                                                              |
[default_temporary_tablespace](#ora_database_default_temporary_tablespace) | Specify the default temporary tablespace.                                                    |
[ensure](#ora_database_ensure)                                             | The basic property that the resource should be in.                                           |
[extent_management](#ora_database_extent_management)                       | Specify the extent management.                                                               |
[file_name_convert](#ora_database_file_name_convert)                       | Enable or disable the containers and adding pluggable databases
                             |
[force_logging](#ora_database_force_logging)                               | Enable or disable the FORCE LOGGING mode.                                                    |
[init_ora_content](#ora_database_init_ora_content)                         | The content of the init.ora parameters.                                                      |
[install_group](#ora_database_install_group)                               | The oracle_install group.                                                                    |
[instances](#ora_database_instances)                                       | One or more instances to be enables on the database
                                         |
[logfile](#ora_database_logfile)                                           | The file to be used as redo log file.                                                        |
[logfile_groups](#ora_database_logfile_groups)                             | Specify the logfile groups.                                                                  |
[maxdatafiles](#ora_database_maxdatafiles)                                 | The initial sizing of the datafiles section of the control file.                             |
[maxinstances](#ora_database_maxinstances)                                 | The maximum number of instances that can simultaneously have this database mounted and open. |
[maxlogfiles](#ora_database_maxlogfiles)                                   | define the limits for the redo log.                                                          |
[maxloghistory](#ora_database_maxloghistory)                               | define the limits for the redo log.                                                          |
[maxlogmembers](#ora_database_maxlogmembers)                               | The maximum number of members, or copies, for a redo log file group.                         |
[name](#ora_database_name)                                                 | The database name.                                                                           |
[national_character_set](#ora_database_national_character_set)             | The national character set used to store data in columns.                                    |
[options](#ora_database_options)                                           |     Specify the options that need to be enabled in the database.                             |
[oracle_base](#ora_database_oracle_base)                                   | The oracle_base directory.                                                                   |
[oracle_home](#ora_database_oracle_home)                                   | The oracle_home directory.                                                                   |
[oracle_user](#ora_database_oracle_user)                                   | The oracle user.                                                                             |
[pdb_admin_password](#ora_database_pdb_admin_password)                     | Specify the password for the admin user of the pluggable database.                           |
[pdb_admin_user](#ora_database_pdb_admin_user)                             | Specify the admin user for the pluggable database.                                           |
[provider](#ora_database_provider)                                         | resource.                                                                                    |
[scan_name](#ora_database_scan_name)                                       | The SCAN name for a RAC cluster.                                                             |
[scan_port](#ora_database_scan_port)                                       | The scan port number for a RAC cluster.                                                      |
[spfile_location](#ora_database_spfile_location)                           | Location of the database's spfile.                                                           |
[state](#ora_database_state)                                               | State of the database, either runnuning or stopped.                                          |
[sys_password](#ora_database_sys_password)                                 | The password of the SYS account.                                                             |
[sysaux_datafiles](#ora_database_sysaux_datafiles)                         | One or more files to be used as sysaux datafiles.                                            |
[system_password](#ora_database_system_password)                           | The password of the SYSTEM account.                                                          |
[tablespace_type](#ora_database_tablespace_type)                           | Use this set the default type created tablespaces including SYSTEM and SYSAUX tablespaces.   |
[timeout](#ora_database_timeout)                                           | Timeout for applying a resource in seconds.                                                  |
[timezone](#ora_database_timezone)                                         | Set the time zone of the database.                                                           |
[undo_tablespace](#ora_database_undo_tablespace)                           | Specify the default tablespace.                                                              |




### archivelog<a name='ora_database_archivelog'>

Enable or disable archive log.

Valid values are `enabled`, `disabled`. 
[Back to overview of ora_database](#attributes)


### autostart<a name='ora_database_autostart'>

Add autostart to the oratab entry.

Valid values are `true`, `false`. 
[Back to overview of ora_database](#attributes)


### character_set<a name='ora_database_character_set'>

Specify the character set the database uses to store data.


[Back to overview of ora_database](#attributes)


### config_scripts<a name='ora_database_config_scripts'>

A list of one or more files to be used to create the catalog and/or custom
environment after the initial database fileset has been created.

Use this syntax to specify all attributes:

    ora_database{'dbname':
      ...
      config_scripts  => [
        { sr01 => template('myconfig/Catalog.sql.erb'),      },
        { sr02 => template('myconfig/Cwmlite.sql.erb'),      },
        { sr03 => template('myconfig/Xdb_Protocol.sql.erb'), },
        { sr04 => template('myconfig/Grants.sql.erb'),       },
      ],
    }


[Back to overview of ora_database](#attributes)


### contained_by<a name='ora_database_contained_by'>

Specify the SID of the container database where the pluggable databases should be part of.
This parameter is mandatory when creating a pluggable databases.

    ora_database { 'my_database':
      ensure             => present,
      ...
      contained_by       => 'CDB',
      ...
    }


[Back to overview of ora_database](#attributes)


### container_database<a name='ora_database_container_database'>

Enable or disable the containers and adding pluggable databases

Using this parameter, you can enable this database,beeing a host for plugganle databases.

    ora_database { 'my_database':
      ensure             => present,
      ...
      container_database => 'enabled',
      ...
    }

Will enable this database to be a host for pluggable databases. This feature needs Oracle 12 or higher. If you
use this feature on a database before Oracle 12, SQL will throw an error.

Valid values are `enabled`, `disabled`. 
[Back to overview of ora_database](#attributes)


### control_file<a name='ora_database_control_file'>

Specify reuse, to reuse existing control files.

Valid values are `reuse`. 
[Back to overview of ora_database](#attributes)


### datafiles<a name='ora_database_datafiles'>

One or more files to be used as datafiles.

Use this syntax to specify all attributes:

    ora_database{'dbname':
      ...
      datafiles       => [
        {file_name   => 'file1.dbs', size => '10G', reuse => true},
        {file_name   => 'file2.dbs', size => '10G', reuse => true},
      ]
    }


[Back to overview of ora_database](#attributes)


### default_tablespace<a name='ora_database_default_tablespace'>

Specify the default tablespace.

Use this syntax to specify all attributes:

    ora_database{'dbname':
      ...
      default_tablespace => {
        name      => 'USERS',
        datafile  => {
          file_name  => 'users.dbs',
          size       => '10G',
          reuse      =>  true,
        }
        extent_management => {
          type          => 'local',
          autoallocate  => true, (mutual exclusive with uniform size)
          uniform_size  => '5G',
        }
      }
    }


[Back to overview of ora_database](#attributes)


### default_temporary_tablespace<a name='ora_database_default_temporary_tablespace'>

Specify the default temporary tablespace.

Use this syntax to specify all attributes:

    ora_database{'dbname':
      ...
      default_temporary_tablespace => {
        name      => 'TEMP',
        tempfile  => {
          file_name  => 'tmp.dbs',
          size       => '10G',
          reuse      =>  true,
          autoextend => {
            maxsize => 'unlimited',
            next    => '1G',
          }
        }
        extent_management => {
          type          => 'local',
          autoallocate  => true, (mutual exclusive with uniform segment size)
          uniform_size  => '5G',
        }
      }
    }


[Back to overview of ora_database](#attributes)


### ensure<a name='ora_database_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_database](#attributes)


### extent_management<a name='ora_database_extent_management'>

Specify the extent management.

Use this syntax to specify all attributes:

    ora_database{'dbname':
      ...
      extent_management => 'local'
    }

Valid values are `local`. 
[Back to overview of ora_database](#attributes)


### file_name_convert<a name='ora_database_file_name_convert'>

Specify the conversion rules for seed files of pluggable databases
Enable or disable the containers and adding pluggable databases

    ora_database { 'my_database':
      ensure             => present,
      ...
      container_database => 'enabled',
      file_name_convert  => {/oracle/dbs/' =>'/oracle/pdbseed/',}
      ...
    }

This will create a container database and convert all file names from the seed database containing
`/oracle/dbs/` to `/oracle/pdbseed`.


[Back to overview of ora_database](#attributes)


### force_logging<a name='ora_database_force_logging'>

Enable or disable the FORCE LOGGING mode.

Valid values are `enabled`, `disabled`. 
[Back to overview of ora_database](#attributes)


### init_ora_content<a name='ora_database_init_ora_content'>

The content of the init.ora parameters. The next set of parameters are managed by the
ora_database custom type:
  - cluster_database
  - remote_listener
  - control_files
  - *.instance_number
  - *.instance_thread
  - *.undo_tablespace

An example:

    ora_database{'db1':
      ...
      init_ora_content => template('database/my_init_ora_content.ora.erb')
      ...
    }


[Back to overview of ora_database](#attributes)


### install_group<a name='ora_database_install_group'>

The oracle_install group.


[Back to overview of ora_database](#attributes)


### instances<a name='ora_database_instances'>

One or more instances to be enables on the database

Use this syntax to specify all attributes:

    ora_database{'dbname':
      ...
      instances       => {
        instance1   => host1,
        instance2   => host2,
      }
    }


[Back to overview of ora_database](#attributes)


### logfile<a name='ora_database_logfile'>

The file to be used as redo log file.


[Back to overview of ora_database](#attributes)


### logfile_groups<a name='ora_database_logfile_groups'>

Specify the logfile groups.

Use this syntax to specify all attributes of the logfile groups. When you want
use one log file per group and use group numbers starting from 1 up, you can
use the easy implementation:

    ora_database{'dbname':
      ...
      logfile_groups => [
          {file_name => 'test1.log', size => '10M', reuse => true},
          {file_name => 'test2.log', size => '10M', reuse => true},
        ],
    }

When you want to use more logfiles per loggroup and/or use specific log group
numbers, you need to use the extended implementation:

    ora_database{'dbname':
      ...
      logfile_groups => [
          {group => 10, file_name => 'test10a.log', size => '10M', reuse => true},
          {group => 10, file_name => 'test10b.log', size => '10M', reuse => true},
          {group => 20, file_name => 'test20a.log', size => '10M', reuse => true},
          {group => 20, file_name => 'test20b.log', size => '10M', reuse => true},
        ],
    }


[Back to overview of ora_database](#attributes)


### maxdatafiles<a name='ora_database_maxdatafiles'>

The initial sizing of the datafiles section of the control file.


[Back to overview of ora_database](#attributes)


### maxinstances<a name='ora_database_maxinstances'>

The maximum number of instances that can simultaneously have this database mounted and open.


[Back to overview of ora_database](#attributes)


### maxlogfiles<a name='ora_database_maxlogfiles'>

define the limits for the redo log.


[Back to overview of ora_database](#attributes)


### maxloghistory<a name='ora_database_maxloghistory'>

define the limits for the redo log.


[Back to overview of ora_database](#attributes)


### maxlogmembers<a name='ora_database_maxlogmembers'>

The maximum number of members, or copies, for a redo log file group.


[Back to overview of ora_database](#attributes)


### name<a name='ora_database_name'>

The database name.


[Back to overview of ora_database](#attributes)


### national_character_set<a name='ora_database_national_character_set'>

The national character set used to store data in columns.


[Back to overview of ora_database](#attributes)


### options<a name='ora_database_options'>

    Specify the options that need to be enabled in the database.

ora_database{'dbname':
  ...
  options => [
      'OWM',
      'JServer',
      'CTX',
      'ORD',
      'IM',
      'OLAP',
      'SDO',        # Requires XDB(default), JServer and ORD
      'OLS',
      'Sample',     # Requires installation of Oracle Database Examples
      'APEX',
      'DV'
    ],
}


[Back to overview of ora_database](#attributes)


### oracle_base<a name='ora_database_oracle_base'>

The oracle_base directory.


[Back to overview of ora_database](#attributes)


### oracle_home<a name='ora_database_oracle_home'>

The oracle_home directory.


[Back to overview of ora_database](#attributes)


### oracle_user<a name='ora_database_oracle_user'>

The oracle user.


[Back to overview of ora_database](#attributes)


### pdb_admin_password<a name='ora_database_pdb_admin_password'>

Specify the password for the admin user of the pluggable database.
This parameter is mandatory when creating a pluggable databases.

ora_database { 'my_database':
  ensure             => present,
  ...
  pdb_admin_password => 'password',
  ...
}


[Back to overview of ora_database](#attributes)


### pdb_admin_user<a name='ora_database_pdb_admin_user'>

Specify the admin user for the pluggable database.
This parameter is mandatory when creating a pluggable databases.

ora_database { 'my_database':
  ensure             => present,
  ...
  pdb_admin_user     => 'password',
  ...
}


[Back to overview of ora_database](#attributes)


### provider<a name='ora_database_provider'>

The specific backend to use for this `ora_database`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage an Oracle Database


[Back to overview of ora_database](#attributes)


### scan_name<a name='ora_database_scan_name'>

The SCAN name for a RAC cluster.
This parameter is only used when you are creating a RAC database by specifying
the instances parameter. Here is an example:

    ora_database{'db':
      ...
      instances   => {'db1' => 'node1', 'db2' => 'node2'},
      scan_name   => 'scan',
      scan_port   => '1521',
    }


[Back to overview of ora_database](#attributes)


### scan_port<a name='ora_database_scan_port'>

The scan port number for a RAC cluster. This parameter is only used when you are creating
a RAC database by specicying the instances parameter. Here is an example:

    ora_database{'db':
      ...
      instances   => {'db1' => 'node1', 'db2' => 'node2'},
      scan_name   => 'scan',
      scan_port   => '1521',
    }


[Back to overview of ora_database](#attributes)


### spfile_location<a name='ora_database_spfile_location'>

Location of the database's spfile. If you specify this paramater, a spfile will be
created at the specified location. If you don't specify this parameter **no** spfile
will be created.

You can use this parameter like this:

    ora_database{'db1':
      ...
      spfile_location => '/opt/oracle/...../dbs/',
    }

or

    ora_database{'db1':
      ...
      spfile_location => '+RECODG',
    }


[Back to overview of ora_database](#attributes)


### state<a name='ora_database_state'>

State of the database, either runnuning or stopped.

Valid values are `running`, `stopped`. 
[Back to overview of ora_database](#attributes)


### sys_password<a name='ora_database_sys_password'>

The password of the SYS account.
This parameter is mandatory when creating a (container) database.


[Back to overview of ora_database](#attributes)


### sysaux_datafiles<a name='ora_database_sysaux_datafiles'>

One or more files to be used as sysaux datafiles.

Use this syntax to specify all attributes:

    ora_database{'dbname':
      ...
      sysaux_datafiles       => [
        {file_name   => 'sysaux1.dbs', size => '10G', reuse => true},
        {file_name   => 'sysaux2.dbs', size => '10G', reuse => true},
      ]
    }


[Back to overview of ora_database](#attributes)


### system_password<a name='ora_database_system_password'>

The password of the SYSTEM account.
This parameter is mandatory when creating a (container) database.


[Back to overview of ora_database](#attributes)


### tablespace_type<a name='ora_database_tablespace_type'>

Use this set the default type created tablespaces including SYSTEM and SYSAUX tablespaces.

Valid values are `bigfile`, `smallfile`. 
[Back to overview of ora_database](#attributes)


### timeout<a name='ora_database_timeout'>

Timeout for applying a resource in seconds.

To be sure no Puppet operation, hangs a Puppet run, all operations have a timeout. When this timeout
expires, Puppet will abort the current operation and signal an error in the Puppet run.

With this parameter, you can specify the length of the timeout. The value is specified in seconds. In
this example, the `timeout`  is set to `600`  seconds.

    ora_type{ ...:
      ...
      timeout => 600,
    }

The default value for `timeout` is 300 seconds.


[Back to overview of ora_database](#attributes)


### timezone<a name='ora_database_timezone'>

Set the time zone of the database.


[Back to overview of ora_database](#attributes)


### undo_tablespace<a name='ora_database_undo_tablespace'>

Specify the default tablespace.

Use this syntax to specify all attributes:

    ora_database{'dbname':
      ...
      undo_tablespace => {
        name      => 'UNDOTBS',
        type      => 'bigfile',
        datafile  => {
          file_name  => 'undo.dbs',
          size       => '10G',
          reuse      =>  true,
        }
      }
    }


[Back to overview of ora_database](#attributes)

