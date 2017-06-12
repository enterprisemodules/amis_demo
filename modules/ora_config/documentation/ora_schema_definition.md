---
title: ora_schema_definition
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This resource allows you to manage a schema definition. This includes all tables, indexes and other DDL that is needed for your application.

    ora_schema_definition{'MYAPP':
        ensure      => '1.0.0',
        schema_name => 'MYAPP,
        password    => 'verysecret',
        source_path => '/opt/stage/myapp/sql',
    }

In this example we tell Puppet, we need schema version `1.0.0` for `MYAPP` in the database. In layman's terms
now the following things will happen:

- The Puppet type will log in to the database using username `myapp` and the very secret password and it will look at the version of the schema already available.
- If the current version is lower than the specified version, Puppet will execute the upgrade SQL scripts in the source path until the correct version is reached.
- If the current version is higher than the requested version, Puppet will execute the downgrade scripts until the requested version is reached.

## Schema version?

What is this concept of a schema version? To administer the current version, Puppet uses a table called `SCHEMA_VERSION`.
Here is the definition of this table:

    CREATE TABLE schema_version
    (  id                NUMBER
      ,application       VARCHAR2(255)
      ,version           VARCHAR2(255)
      ,description       VARCHAR2(255)
      ,installation_time TIMESTAMP(6)
    );

Puppet uses this table to store the history of all schema versions applied. If the table doesn't exists, Puppet will
create it for you. Using this information, Puppet can tell what the state of the current schema in the database is.
Puppet creates this table for every single schema/user you manage. This means, you can have multiple schemas with
different versions in your database.

## What about these upgrade and downgrade scripts.

In order for Puppet to do it's magic, the upgrade and downgrade scripts, need to have specific names.
Here is a listing of some upgrade scripts:

    upgrades/0000_myapp_0.0.1_initial-schema.sql
    upgrades/0001_myapp_0.0.2_add-user-table.sql
    upgrades/0002_myapp_0.1.0_initial-release.sql

As you can see, all the file names have the following structure:

- a four-digit sequence number
- application name
- version number
- description

All fields are separated by an underscore. The upgrade scripts contain all SQL statements needed to upgrade
the database schema to the desired state. In general upgrade scripts contain statements to create tables and
indexes and add or remove columns, but you can also insert data into the lookup-tables or create database packages.

The `downgrades` directory contains scripts with the same names. The downgrade scripts contain the SQL statements
needed to put the database in the state it was before. So if you add a column in an upgrade script, you'll have
to remove this column in the downgrade script.

## Attributes



Attribute Name                                    | Short Description                                                |
------------------------------------------------- | ---------------------------------------------------------------- |
[ensure](#ora_schema_definition_ensure)           | version number or the literal `latest`.                          |
[name](#ora_schema_definition_name)               | The schema name.                                                 |
[parameters](#ora_schema_definition_parameters)   | The parameters to pass to the sql upgrade and downgrade scripts. |
[password](#ora_schema_definition_password)       | The user's password.                                             |
[provider](#ora_schema_definition_provider)       | resource.                                                        |
[reinstall](#ora_schema_definition_reinstall)     | Force delete before applying the schema updates.                 |
[schema_name](#ora_schema_definition_schema_name) | The schema name.                                                 |
[sid](#ora_schema_definition_sid)                 | SID to connect to.                                               |
[source_path](#ora_schema_definition_source_path) | the source containing the sql upgrade and downgrade scripts.     |
[tmp_dir](#ora_schema_definition_tmp_dir)         | The tmp extract directory of the schema definition.              |




### ensure<a name='ora_schema_definition_ensure'>

version number or the literal `latest`.

This property allows you to specify the version of the schema you want to have loaded.

Here is an example on how you can use this:

      ora_schema_definition{ 'myapp@sid:
        ...
        password => 'secret',
        ensure   => '2.2.1',
        ...
      }

In layman's terms now the following things will happen:

- The Puppet type will log in to the database using username `myapp` and the very secret password and it will look at the version of the schema already available.
- If the current version is lower than the specified version, Puppet will execute the upgrade SQL scripts in the source path until the correct version is reached.
- If the current version is higher than the requested version, Puppet will execute the downgrade scripts until the requested version is reached.

The version number *MUST* be a string containing 3 point characters separating the major, minor and patch number:

`major.minor.patch`

You can also specify the term `latest`. In that case, Puppet will look in the `source_pad` see what the
highest available version is and ensure that version of the schema is available in the database.

Here is an example on how you can use this:

      ora_schema_definition{ 'my_app@sid:
        ...
        ensure => 'latest',
        ...
      }

Valid values are `absent`, `latest` (also called `present`). Values can match `/^\d{1,3}.\d{1,3}.\d{1,3}$/`.
[Back to overview of ora_schema_definition](#attributes)


### name<a name='ora_schema_definition_name'>

The schema name.


[Back to overview of ora_schema_definition](#attributes)


### parameters<a name='ora_schema_definition_parameters'>

The parameters to pass to the sql upgrade and downgrade scripts.

Sometimes you want to parameterize the upgrade end/or downgrade SQL-scripts. This is supported by the `parameters` property. Here is an example of a definition.

    ora_schema_definition{'MYAPP':
        ensure      => 'latest',
        schema_name => 'MYAPP,
        password    => 'verysecret',
        source_path => '/opt/stage/myapp/sql',
        parameters  => {
          myapp_data_tablespace => 'MYAPP_DATA',
          myapp_idx_tablespace  => 'MYAPP_DATA',
        }
    }

In the SQL-scripts you can use these parameters like this:

    CREATE TABLE order(
    ...
    ) TABLESPACE &myapp_data_tablespace


[Back to overview of ora_schema_definition](#attributes)


### password<a name='ora_schema_definition_password'>

The user's password.


[Back to overview of ora_schema_definition](#attributes)


### provider<a name='ora_schema_definition_provider'>

The specific backend to use for this `ora_schema_definition`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

sqlplus
: Manage The schema definition


[Back to overview of ora_schema_definition](#attributes)


### reinstall<a name='ora_schema_definition_reinstall'>

Force delete before applying the schema updates.


When you set the `reinstall` property to `true`, Puppet will drop all database objects for the specified
user and will re-run all the upgrade scripts until the specified version is reached. This feature comes
in very handy when you use Puppet in your CI environment. Puppet makes sure all old stuff is removed and
al the tables and indexes are in a pristine state before you start your tests.

Here is an example on how to use it:

    ora_schema_definition{'MYAPP':
      ...
      reinstall => true,
      ...
    }

Valid values are `true`, `false`. 
[Back to overview of ora_schema_definition](#attributes)


### schema_name<a name='ora_schema_definition_schema_name'>

The schema name.

The schema name is part of the title of the resource. In this example:

    ora_schema_definition{'MYAPP@SID':
      ensure => latest,
      password => 'secret',
      ...
    }

The schema name is the part of the title before the `@` character. In this case `MYAPP`.
The puppet type uses this as the Oracle user to log in. Yo must specify the password in the
resource definition.


[Back to overview of ora_schema_definition](#attributes)


### sid<a name='ora_schema_definition_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_schema_definition](#attributes)


### source_path<a name='ora_schema_definition_source_path'>

the source containing the sql upgrade and downgrade scripts.

You can use either:

a base directory:

    ora_schema-definition{'app':
      ensure => latest,
      source => '/staging'
    }

or

    ora_schema-definition{'app':
      ensure => latest,
      source => 'file:///staging'
    }

in this case, puppet will look for upgrade and downgrade scripts in:
  /staging/app/sql/upgrades
  /staging/app/sql/downgrades

an url:

    ora_schema-definition{'app':
      ensure   => latest,
      temp_dir => '/tmp/app'
      source   => 'http://host/app010.tar.Z'
    }

In this case, the type will fetch the specfied file from the puppet master, decompress and
untar it into the `temp_dir`. Then the type will search for the `upgrades` and ` downgrades` directorys
in the zip and use those.

The following kind of URL's are supported:

* `puppet:` URIs, which point to files in modules or Puppet file server
mount points.
* Fully qualified paths to locally available files (including files on NFS
shares or Windows mapped drives).
* `file:` URIs, which behave the same as local file paths.
* `http:` URIs, which point to files served by common web servers

The normal form of a `puppet:` URI is:

`puppet:///modules/<MODULE NAME>/<FILE PATH>`

This will fetch a file from a module on the Puppet master (or from a
local module when using Puppet apply). Given a `modulepath` of
`/etc/puppetlabs/code/modules`, the example above would resolve to
`/etc/puppetlabs/code/modules/<MODULE NAME>/files/<FILE PATH>`.

## Container file

When the file is a container file, it will automaticaly be extracted. At this point in
time the follwoing container types are supported:

- zip
- tar

## Compressed files

When the file is compressed, it will be uncompressed before beeing procesed further. This means that for example
a file `https://www.puppet.com/files/all.tar.gz` will be uncompressed before being unpackes with `tar`

## Examples

Here are some examples:

### A puppet url containing a zip file

    ora_schema_definition { '...':
      ...
      source  => 'puppet:///modules/software/software.zip',
      tmp_dir => '/tmp/mysoftware'
      ...
    }

The `software.zip` file will be fetched from the puppet server software module and put in `/tmp/mysoftware`, it will be unzipped and used for the actions
in the custom type. The file will be temporary put in


### A http url containing a tar file

ora_schema_definition { '...':
  ...
  source  => 'http:///www.enterprisemodules.com/software/software.tar',
  tmp_dir => '/tmp/mysoftware'
  ...
}


The `software.tar` file will be fetched from the named web server and put in `/tmp/mysoftware`, it will be untarred and
used for the actions in the custom type.

### A file url fcontaining a compressed tar file

ora_schema_definition { '...':
  ...
  source  => 'file:///nfsshare/software/software.tar.Z',
  tmp_dir => '/tmp/mysoftware'
  ...
}

The `software.tar.Z` file will be fetched from the namedd irectory, it will be uncompressed and then untarred on and put in `/tmp/mysoftware`
and used for the actions in the custom type.


[Back to overview of ora_schema_definition](#attributes)


### tmp_dir<a name='ora_schema_definition_tmp_dir'>

The tmp extract directory of the schema definition.


[Back to overview of ora_schema_definition](#attributes)

