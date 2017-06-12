---
title: ora_record
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This resource allows you to manage a record in an Oracle database table.

Use ora_record to make sure a record with a specfied primary key exists in the specified table. Here is
an exaple:

    ora_record{'set_external_service_name':
      ensure     => 'present',
      table_name => 'CONFIG_DATA',
      key_name   => 'CONFIG_ID',
      key_value  => 10,
      username   => 'ORACLE_USER',
      password   => 'verysecret',
      data       => {
        'CONFIG_NAME'  => 'service_name',
        'CONFIG_VALUE' => 'http://external.data-server.com',
        ...
      }
    }

This Puppet code tells you that the table CONFIG_DATA from user ORACLE_USER must contain a record where
the primary key CONFIG_ID is 10. If Puppet notices that this record doesn’t exist, It will create the
record and fill its data with the data specified in the data property. If Puppet sees that the key already
exists, it does nothing. This code will make sure your database contains the record, but it will not
ALWAYS set the data. This code is useful for example in use cases where there is a set of management
screens to manage these settings. Puppet makes sure the setting exists, but will leave the settings
as they are after the system is running and applications managers might have changed the values.


If you **always** want to make sure the record contains the specfied data, use `updated` for the `ensure`
property.

    ora_record{'set_external_service_name':
      ensure     => 'updated',
      table_name => 'CONFIG_DATA',
      username   => 'ORACLE_USER',
      password   => 'verysecret',
      key_name   => 'CONFIG_ID',
      key_value  => 10,
      data       => {
        'CONFIG_NAME'  => 'service_name',
        'CONFIG_VALUE' => 'http://external.data-server.com',
        ...
      }
    }

Now Puppet will not only check if the record exists, but it will also always make sure the specified columns
contain the specified values. If there are columns you don’t want to manage, then just leave them blank.

## Attributes



Attribute Name                       | Short Description                              |
------------------------------------ | ---------------------------------------------- |
[data](#ora_record_data)             | The data in the row specified as an hash.      |
[ensure](#ora_record_ensure)         | absent, present or updated.                    |
[key_name](#ora_record_key_name)     | The column name of the primary key.            |
[key_value](#ora_record_key_value)   | The key value of the record to manage.         |
[name](#ora_record_name)             | A name for the record and the table to manage. |
[password](#ora_record_password)     | The user's password.                           |
[provider](#ora_record_provider)     | resource.                                      |
[sid](#ora_record_sid)               | SID to connect to.                             |
[table_name](#ora_record_table_name) | The table name.                                |
[username](#ora_record_username)     | The owner of the table.                        |




### data<a name='ora_record_data'>

The data in the row specified as an hash.


[Back to overview of ora_record](#attributes)


### ensure<a name='ora_record_ensure'>

absent, present or updated.

when present is specified, it will just check if the primary key record is available. If it is,
nothing will be done. When you specify 'updated', puppet will ensure the data is as specified
in the data property of the puppet definition.

Valid values are `present`, `updated`, `absent`. 
[Back to overview of ora_record](#attributes)


### key_name<a name='ora_record_key_name'>

The column name of the primary key.


[Back to overview of ora_record](#attributes)


### key_value<a name='ora_record_key_value'>

The key value of the record to manage.


[Back to overview of ora_record](#attributes)


### name<a name='ora_record_name'>

A name for the record and the table to manage.

This can be any name you like.

Example:

    ora_record { 'just_a_name':
      ...
    }


[Back to overview of ora_record](#attributes)


### password<a name='ora_record_password'>

The user's password.


[Back to overview of ora_record](#attributes)


### provider<a name='ora_record_provider'>

The specific backend to use for this `ora_record`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

sqlplus
: Manage a record in an Oracle table via regular SQL


[Back to overview of ora_record](#attributes)


### sid<a name='ora_record_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_record](#attributes)


### table_name<a name='ora_record_table_name'>

The table name.


[Back to overview of ora_record](#attributes)


### username<a name='ora_record_username'>

The owner of the table.

If none is specfied, it will connect as the user specified in ora_setting.


[Back to overview of ora_record](#attributes)

