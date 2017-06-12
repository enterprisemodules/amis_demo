---
title: db listener
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

control the oracle db listener state like running,stop,restart

## Attributes



Attribute Name                                  | Short Description                                         |
----------------------------------------------- | --------------------------------------------------------- |
[ensure](#db_listener_ensure)                   | Whether to do something.                                  |
[listener_name](#db_listener_listener_name)     | Listener name.                                            |
[name](#db_listener_name)                       | The title.                                                |
[oracle_base_dir](#db_listener_oracle_base_dir) | The oracle base folder.                                   |
[oracle_home_dir](#db_listener_oracle_home_dir) | The oracle home folder.                                   |
[os_user](#db_listener_os_user)                 | The weblogic operating system user.                       |
[provider](#db_listener_provider)               | resource.                                                 |
[refreshonly](#db_listener_refreshonly)         | refresh mechanism for when a dependent object is changed. |




### ensure<a name='db_listener_ensure'>

Whether to do something.

Valid values are `start` (also called `running`), `stop` (also called `abort`). 
[Back to overview of db_listener](#attributes)


### listener_name<a name='db_listener_listener_name'>

Listener name.


[Back to overview of db_listener](#attributes)


### name<a name='db_listener_name'>

The title.


[Back to overview of db_listener](#attributes)


### oracle_base_dir<a name='db_listener_oracle_base_dir'>

The oracle base folder.


[Back to overview of db_listener](#attributes)


### oracle_home_dir<a name='db_listener_oracle_home_dir'>

The oracle home folder.


[Back to overview of db_listener](#attributes)


### os_user<a name='db_listener_os_user'>

The weblogic operating system user.


[Back to overview of db_listener](#attributes)


### provider<a name='db_listener_provider'>

The specific backend to use for this `db_listener`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

db_listener
: 


[Back to overview of db_listener](#attributes)


### refreshonly<a name='db_listener_refreshonly'>

The command should only be run as a
refresh mechanism for when a dependent object is changed.

Valid values are `true`, `false`. 
[Back to overview of db_listener](#attributes)

