---
title: db control
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

control the database instance state like running,stop,restart

## Attributes



Attribute Name                                                 | Short Description                                         |
-------------------------------------------------------------- | --------------------------------------------------------- |
[db_type](#db_control_db_type)                                 | The type of instance.                                     |
[ensure](#db_control_ensure)                                   | Whether to do something.                                  |
[grid_product_home_dir](#db_control_grid_product_home_dir)     | The grid product home folder.                             |
[instance_name](#db_control_instance_name)                     | The database instance name.                               |
[name](#db_control_name)                                       | The title.                                                |
[oracle_product_home_dir](#db_control_oracle_product_home_dir) | The oracle product home folder.                           |
[os_user](#db_control_os_user)                                 | The weblogic operating system user.                       |
[provider](#db_control_provider)                               | resource.                                                 |
[refreshonly](#db_control_refreshonly)                         | refresh mechanism for when a dependent object is changed. |




### db_type<a name='db_control_db_type'>

The type of instance.

Valid values are `database`, `asm` (also called `grid`). 
[Back to overview of db_control](#attributes)


### ensure<a name='db_control_ensure'>

Whether to do something.

Valid values are `start` (also called `running`), `stop` (also called `abort, stopped`). 
[Back to overview of db_control](#attributes)


### grid_product_home_dir<a name='db_control_grid_product_home_dir'>

The grid product home folder.


[Back to overview of db_control](#attributes)


### instance_name<a name='db_control_instance_name'>

The database instance name.


[Back to overview of db_control](#attributes)


### name<a name='db_control_name'>

The title.


[Back to overview of db_control](#attributes)


### oracle_product_home_dir<a name='db_control_oracle_product_home_dir'>

The oracle product home folder.


[Back to overview of db_control](#attributes)


### os_user<a name='db_control_os_user'>

The weblogic operating system user.


[Back to overview of db_control](#attributes)


### provider<a name='db_control_provider'>

The specific backend to use for this `db_control`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

base
: 

sqlplus
: * Default for `id` == `root`.

srvctl
: 


[Back to overview of db_control](#attributes)


### refreshonly<a name='db_control_refreshonly'>

The command should only be run as a
refresh mechanism for when a dependent object is changed.

Valid values are `true`, `false`. 
[Back to overview of db_control](#attributes)

