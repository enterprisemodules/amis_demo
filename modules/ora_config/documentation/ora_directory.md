---
title: ora_directory
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview


This resource allows you to manage directory mappings from inside an Oracle database to
a directory outside of the database. Here is an example:

    ora_directory { 'ORACLE_OCM_CONFIG_DIR2@test':
      ensure         => 'present',
      directory_path => '/opt/oracle/app/11.04/ccr/state',
    }

## Attributes



Attribute Name                                  | Short Description                                            |
----------------------------------------------- | ------------------------------------------------------------ |
[directory_name](#ora_directory_directory_name) | The directory name
                                          |
[directory_path](#ora_directory_directory_path) |   	The physical pathname of the directory on the filesystem. |
[ensure](#ora_directory_ensure)                 | The basic property that the resource should be in.           |
[name](#ora_directory_name)                     | The directory name
                                          |
[provider](#ora_directory_provider)             | resource.                                                    |
[sid](#ora_directory_sid)                       | SID to connect to.                                           |




### directory_name<a name='ora_directory_directory_name'>

The directory name


[Back to overview of ora_directory](#attributes)


### directory_path<a name='ora_directory_directory_path'>

  	The physical pathname of the directory on the filesystem.

ora_directory { 'ORACLE_OCM_CONFIG_DIR2@test':
	...
  directory_path => '/opt/oracle/app/11.04/ccr/state',
  ...
}


[Back to overview of ora_directory](#attributes)


### ensure<a name='ora_directory_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_directory](#attributes)


### name<a name='ora_directory_name'>

The directory name


[Back to overview of ora_directory](#attributes)


### provider<a name='ora_directory_provider'>

The specific backend to use for this `ora_directory`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage directory mappings in an Oracle Database via regular SQL


[Back to overview of ora_directory](#attributes)


### sid<a name='ora_directory_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_directory](#attributes)

