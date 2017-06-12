---
title: listener
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

Manage the oracle listener[DEPRECATED]

This defined type is deprecated. Please use [db_listener](TODO) custom type to manage your listener.

Here is an example on how to use this:

```puppet
ora_install::listener{'start listener':
  action        => 'start',  # running|start|abort|stop
  oracle_base   => '/oracle',
  oracle_home   => '/oracle/product/11.2/db',
  user          => 'oracle',
  group         => 'dba',
  listener_name => 'listener' # which is the default and optional
}
```





## Attributes



Attribute Name                           | Short Description                                                  |
---------------------------------------- | ------------------------------------------------------------------ |
[action](#listener_action)               | The action to take.                                                |
[group](#listener_group)                 | The os group to use for these Oracle puppet definitions.           |
[listener_name](#listener_listener_name) | The name of the listener process.                                  |
[oracle_home](#listener_oracle_home)     | A directory to be used as Oracle home directory for this software. |
[user](#listener_user)                   | The user used for the specified installation.                      |




### action<a name='listener_action'>

The action to take.

Valid values are:
- `running`
- `start`
- `abort`
- `stop`

The default value is `start`.

[Back to overview of listener](#attributes)


### group<a name='listener_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of listener](#attributes)


### listener_name<a name='listener_listener_name'>

The name of the listener process.

The default value is `listener`.

[Back to overview of listener](#attributes)


### oracle_home<a name='listener_oracle_home'>

A directory to be used as Oracle home directory for this software.

[Back to overview of listener](#attributes)


### user<a name='listener_user'>

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

[Back to overview of listener](#attributes)

