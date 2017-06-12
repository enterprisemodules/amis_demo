---
title: tnsnames
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

Manages an entry in a `tnsnames.ora` file.

Here is an examples on how to use this:

```puppet
oradb::tnsnames{'entry':
  oracle_home          => '/oracle/product/11.2/db',
  user                 => 'oracle',
  group                => 'dba',
  server               => { myserver => { host => soadb.example.nl, port => '1525', protocol => 'TCP' }, { host => soadb2.example.nl, port => '1526', protocol => 'TCP' }},
  connect_service_name => 'soarepos.example.nl',
  connect_server       => 'DEDICATED',
}
```




## Attributes



Attribute Name                                         | Short Description                                                  |
------------------------------------------------------ | ------------------------------------------------------------------ |
[connect_server](#tnsnames_connect_server)             | The name of the server to connect to.                              |
[connect_service_name](#tnsnames_connect_service_name) | The name of the service to connect to.                             |
[entry_type](#tnsnames_entry_type)                     | The type of entry to manage.                                       |
[failover](#tnsnames_failover)                         | Failover ON or OFF.                                                |
[group](#tnsnames_group)                               | The os group to use for these Oracle puppet definitions.           |
[loadbalance](#tnsnames_loadbalance)                   | Load balance ON or OFF.                                            |
[oracle_home](#tnsnames_oracle_home)                   | A directory to be used as Oracle home directory for this software. |
[server](#tnsnames_server)                             | A Hash defining the server entry.                                  |
[user](#tnsnames_user)                                 | The user used for the specified installation.                      |




### connect_server<a name='tnsnames_connect_server'>

The name of the server to connect to.

[Back to overview of tnsnames](#attributes)


### connect_service_name<a name='tnsnames_connect_service_name'>

The name of the service to connect to.

[Back to overview of tnsnames](#attributes)


### entry_type<a name='tnsnames_entry_type'>

The type of entry to manage.

You can manage the next type of entries:
- `tnsname`
- `listener`

The default is `tnsname`.

[Back to overview of tnsnames](#attributes)


### failover<a name='tnsnames_failover'>

Failover ON or OFF.

Valid values are:
- `ON`
- `OFF`

The default value is `ON`.

[Back to overview of tnsnames](#attributes)


### group<a name='tnsnames_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of tnsnames](#attributes)


### loadbalance<a name='tnsnames_loadbalance'>

Load balance ON or OFF.

Valid values are:
- `ON`
- `OFF`

The default value is `ON`.

[Back to overview of tnsnames](#attributes)


### oracle_home<a name='tnsnames_oracle_home'>

A directory to be used as Oracle home directory for this software.

[Back to overview of tnsnames](#attributes)


### server<a name='tnsnames_server'>

A Hash defining the server entry.

The default value is
```
{myserver => { host => undef, port => '1521', protocol => 'TCP' }}
```

[Back to overview of tnsnames](#attributes)


### user<a name='tnsnames_user'>

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

[Back to overview of tnsnames](#attributes)

