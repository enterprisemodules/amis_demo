---
title: ora_setting
keywords: documentation
layout: documentation
sidebar: _sidebar
toc: false
---
## Overview

This resource allows you to set the defaults for all other ora types.


All ora types need a `ora_setting` definition. This is a pointer to a local or remote database.
You need to create one for every local, remote or pluggable database you want to manage.
When you don't provide a `ora_setting` identifier in the title of the oracle type then it will use `default` as identifier.
The connect string is according to the EZCONNECT naming method.

Here is an example on how to create the `default` settings:

    ora_setting { '<SID>':
      default        => true|false,
      user           => '<username>',
      password       => '<password>',
      syspriv        => 'sysdba|sysasm|sysoper|sysbackup|sysdg|syskm',
      oracle_home    => '<path>',
      connect_string => "[//]host[:port][/service_name][:server][/instance]",
      pluggable      => true|false,
    }

If you want to manage a remote database, like for instance `DB1`. You will have to specify a local oracle_home from where sqlplus can be started.
You use `ora_setting` like this:

    ora_setting { 'DB1':
      default        => true,
      user           => 'sys',
      password       => 'password',
      syspriv        => 'sysdba',
      oracle_home    => '/opt/oracle/12.1.0.2/db',
      connect_string => '//host1:1522/DB1',
      pluggable      => false,
    }

## Attributes



Attribute Name                                | Short Description                                                             |
--------------------------------------------- | ----------------------------------------------------------------------------- |
[cdb](#ora_setting_cdb)                       | Is the database we manage a container database? If so set this value to true. |
[connect_string](#ora_setting_connect_string) | The connect string to use for the database.                                   |
[contained_by](#ora_setting_contained_by)     | The container database where this pluggable belings to.                       |
[default](#ora_setting_default)               | Oracle types.                                                                 |
[name](#ora_setting_name)                     | The name of the setting.                                                      |
[oracle_home](#ora_setting_oracle_home)       | The ORACLE_HOME where sqlplus can be found.                                   |
[os_user](#ora_setting_os_user)               | The database username to use for database sysdba operations.                  |
[password](#ora_setting_password)             | The password to use for database `sys` operations.                            |
[pluggable](#ora_setting_pluggable)           | Is the database we manage a pluggable database? If so set this value to true. |
[provider](#ora_setting_provider)             | resource.                                                                     |
[syspriv](#ora_setting_syspriv)               | The privilege used to connect to the database or asm.                         |
[user](#ora_setting_user)                     | The database username to use for database sysdba operations.                  |




### cdb<a name='ora_setting_cdb'>

Is the database we manage a container database? If so set this value to true.
When you set this property to `true`, you enable container_database behaviour for this database. Here is
an example on how to use this.
    ora_setting {container_database
      ...
      cdb => true
      ...
    }

Valid values are `true`, `false`. 
[Back to overview of ora_setting](#attributes)


### connect_string<a name='ora_setting_connect_string'>

The connect string to use for the database.

Here is an example:

    ora_setting { 'DB1':
      ...
      connect_string     => "//host1:1522/DB1",
      ...
    }


[Back to overview of ora_setting](#attributes)


### contained_by<a name='ora_setting_contained_by'>

The container database where this pluggable belings to.

Here is an example:

    ora_setting { 'DB1':
      ...
      contained_by     => "CDB",
      ...
    }


[Back to overview of ora_setting](#attributes)


### default<a name='ora_setting_default'>

When you set this value to true, this database will be used when no explcit `sid` is specified on the
Oracle types.

Many of the of the oracle types, allow you to NOT specfify the `sid` and use a default `sid`. This makes
puppet manifests easier readable and less verbose when creating a manifest for a single database.

The databasse for which you set the property `default` to `true`, is the database that will be used for those
operations.

Valid values are `true`, `false`. 
[Back to overview of ora_setting](#attributes)


### name<a name='ora_setting_name'>

The name of the setting. This must be equal to the `sid` of the database.


[Back to overview of ora_setting](#attributes)


### oracle_home<a name='ora_setting_oracle_home'>

The ORACLE_HOME where sqlplus can be found.

This is a required setting. Here is an example on how to use this:

    ora_setting { 'DB1':
      ...
      oracle_home        => '/opt/oracle/12.1.0.2/db',
      ...
    }


[Back to overview of ora_setting](#attributes)


### os_user<a name='ora_setting_os_user'>

The os username to use for local Database operations
The database username to use for database sysdba operations. This value is required when the database is not local. E.g the
database is running on a remote server and is connected to through a remote connection string.

Here is an example on how to use this:

    ora_setting { 'DB1':
      ...
      os_user => 'oracle',
      ...
    }

When you don't specify a value, Puppet takes the value `oracle` as default for
regular databases. For ASM databases, it uses the value `grid`,


[Back to overview of ora_setting](#attributes)


### password<a name='ora_setting_password'>

The password to use for database `sys` operations. This value is required when the database is not local. E.g the
database is running on a remote server and is connected to through a remote connection string.

Here is an example on how to use this:

ora_setting { 'DB1':
  ...
  user               => 'sys',
  password           => 'password',
  ...
}


[Back to overview of ora_setting](#attributes)


### pluggable<a name='ora_setting_pluggable'>

Is the database we manage a pluggable database? If so set this value to true.

When you set this property to `true`, you enable pluggable behaviour for this database. Here is
an example on how to use this.

    ora_setting {container_database
      ...
      pluggable => true,
      ...
    }

Valid values are `true`, `false`. 
[Back to overview of ora_setting](#attributes)


### provider<a name='ora_setting_provider'>

The specific backend to use for this `ora_setting`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage ora settings through yaml file


[Back to overview of ora_setting](#attributes)


### syspriv<a name='ora_setting_syspriv'>

The privilege used to connect to the database or asm.

You need to set this depending on the type of database.

    ora_setting { 'DB1':
      syspriv => 'sysdba',
    }

Valid values are `normal`, `sysdba`, `sysasm`, `sysoper`, `sysbackup`, `sysdg`, `syskm`. 
[Back to overview of ora_setting](#attributes)


### user<a name='ora_setting_user'>

The database username to use for database sysdba operations. This value is required when the database is not local. E.g the
database is running on a remote server and is connected to through a remote connection string.

Here is an example on how to use this:

    ora_setting { 'DB1':
      ...
      user               => 'sys',
      password           => 'password',
      ...
    }


[Back to overview of ora_setting](#attributes)

