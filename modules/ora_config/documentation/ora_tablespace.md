---
title: ora_tablespace
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you to manage an Oracle tablespace.

It recognises most of the options that [CREATE TABLESPACE](http://docs.oracle.com/cd/B28359_01/server.111/b28310/tspaces002.htm#ADMIN11359) supports.

    ora_tablespace {'my_app_ts@sid':
      ensure                    => present,
      datafile                  => 'my_app_ts.dbf',
      size                      => 5G,
      logging                   => yes,
      autoextend                => on,
      next                      => 100M,
      max_size                  => 20G,
      extent_management         => local,
      segment_space_management  => auto,
    }

You can also create an undo tablespace:

    ora_tablespace {'my_undots_1@sid':
      ensure                    => present,
      contents                  => 'undo',
    }

or a temporary tablespace:

    tablespace {'my_temp_ts@sid':
      ensure                    => present,
      datafile                  => 'my_temp_ts.dbf',
      contents                  => 'temporary',
      size                      => 5G,
      logging                   => yes,
      autoextend                => on,
      next                      => 100M,
      max_size                  => 20G,
      extent_management         => local,
      segment_space_management  => auto,
    }

## Attributes



Attribute Name                                                       | Short Description                                                    |
-------------------------------------------------------------------- | -------------------------------------------------------------------- |
[autoextend](#ora_tablespace_autoextend)                             | Enable autoextension for the tablespace.                             |
[bigfile](#ora_tablespace_bigfile)                                   | Specify if you want a `bigfile` or a `smallfile` tablespace.         |
[block_size](#ora_tablespace_block_size)                             | The block size to use for the tablespace.                            |
[contents](#ora_tablespace_contents)                                 | What does the tablespace contain? permanent, temporary of undo data. |
[datafile](#ora_tablespace_datafile)                                 | The name of the datafile.                                            |
[ensure](#ora_tablespace_ensure)                                     | The basic property that the resource should be in.                   |
[extent_management](#ora_tablespace_extent_management)               | TODO: Give description.                                              |
[logging](#ora_tablespace_logging)                                   | TODO: Add description.                                               |
[max_size](#ora_tablespace_max_size)                                 | Maximum size for autoextending.                                      |
[name](#ora_tablespace_name)                                         | The tablespace name.                                                 |
[next](#ora_tablespace_next)                                         | Size of the next autoextent.                                         |
[provider](#ora_tablespace_provider)                                 | resource.                                                            |
[segment_space_management](#ora_tablespace_segment_space_management) | TODO: Give description.                                              |
[sid](#ora_tablespace_sid)                                           | SID to connect to.                                                   |
[size](#ora_tablespace_size)                                         | The size of the tablespace.                                          |
[tablespace_name](#ora_tablespace_tablespace_name)                   | The tablespace name.                                                 |
[timeout](#ora_tablespace_timeout)                                   | Timeout for applying a resource in seconds.                          |




### autoextend<a name='ora_tablespace_autoextend'>

Enable autoextension for the tablespace.

Valid values are `on` (also called `yes, true`), `off` (also called `no, false`). 
[Back to overview of ora_tablespace](#attributes)


### bigfile<a name='ora_tablespace_bigfile'>

Specify if you want a `bigfile` or a `smallfile` tablespace.

Valid values are `yes`, `no`. 
[Back to overview of ora_tablespace](#attributes)


### block_size<a name='ora_tablespace_block_size'>

The block size to use for the tablespace.


[Back to overview of ora_tablespace](#attributes)


### contents<a name='ora_tablespace_contents'>

What does the tablespace contain? permanent, temporary of undo data.

Valid values are `permanent`, `temporary`, `undo`. 
[Back to overview of ora_tablespace](#attributes)


### datafile<a name='ora_tablespace_datafile'>

The name of the datafile.


[Back to overview of ora_tablespace](#attributes)


### ensure<a name='ora_tablespace_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_tablespace](#attributes)


### extent_management<a name='ora_tablespace_extent_management'>

TODO: Give description.

Valid values are `local`, `dictionary`. 
[Back to overview of ora_tablespace](#attributes)


### logging<a name='ora_tablespace_logging'>

TODO: Add description.

Valid values are `yes`, `no`. 
[Back to overview of ora_tablespace](#attributes)


### max_size<a name='ora_tablespace_max_size'>

Maximum size for autoextending.


[Back to overview of ora_tablespace](#attributes)


### name<a name='ora_tablespace_name'>

The tablespace name.


[Back to overview of ora_tablespace](#attributes)


### next<a name='ora_tablespace_next'>

Size of the next autoextent.


[Back to overview of ora_tablespace](#attributes)


### provider<a name='ora_tablespace_provider'>

The specific backend to use for this `ora_tablespace`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage an Oracle Tablespace in an Oracle Database via regular SQL


[Back to overview of ora_tablespace](#attributes)


### segment_space_management<a name='ora_tablespace_segment_space_management'>

TODO: Give description.

Valid values are `auto`, `manual`. 
[Back to overview of ora_tablespace](#attributes)


### sid<a name='ora_tablespace_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_tablespace](#attributes)


### size<a name='ora_tablespace_size'>

The size of the tablespace.


[Back to overview of ora_tablespace](#attributes)


### tablespace_name<a name='ora_tablespace_tablespace_name'>

The tablespace name.


[Back to overview of ora_tablespace](#attributes)


### timeout<a name='ora_tablespace_timeout'>

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


[Back to overview of ora_tablespace](#attributes)

