---
title: db rcu
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

This is the Oracle RCU ( Repository creation utility) installer type

## Attributes



Attribute Name                       | Short Description                               |
------------------------------------ | ----------------------------------------------- |
[db_server](#db_rcu_db_server)       | The database server for the RCU check/install.  |
[db_service](#db_rcu_db_service)     | The database service for the RCU check/install. |
[ensure](#db_rcu_ensure)             | Whether a Repository should be created.         |
[name](#db_rcu_name)                 | The prefix of the RCU.                          |
[oracle_home](#db_rcu_oracle_home)   | The oracle database home folder.                |
[os_user](#db_rcu_os_user)           | The weblogic operating system user.             |
[provider](#db_rcu_provider)         | resource.                                       |
[statement](#db_rcu_statement)       | The RCU statement.                              |
[sys_password](#db_rcu_sys_password) | The sys password for the RCU check/install.     |
[sys_user](#db_rcu_sys_user)         | The sys username for the RCU check/install.     |




### db_server<a name='db_rcu_db_server'>

The database server for the RCU check/install.


[Back to overview of db_rcu](#attributes)


### db_service<a name='db_rcu_db_service'>

The database service for the RCU check/install.


[Back to overview of db_rcu](#attributes)


### ensure<a name='db_rcu_ensure'>

Whether a Repository should be created.

Valid values are `present` (also called `create`), `absent` (also called `delete`). 
[Back to overview of db_rcu](#attributes)


### name<a name='db_rcu_name'>

The prefix of the RCU.


[Back to overview of db_rcu](#attributes)


### oracle_home<a name='db_rcu_oracle_home'>

The oracle database home folder.


[Back to overview of db_rcu](#attributes)


### os_user<a name='db_rcu_os_user'>

The weblogic operating system user.


[Back to overview of db_rcu](#attributes)


### provider<a name='db_rcu_provider'>

The specific backend to use for this `db_rcu`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

db_rcu
: 


[Back to overview of db_rcu](#attributes)


### statement<a name='db_rcu_statement'>

The RCU statement.


[Back to overview of db_rcu](#attributes)


### sys_password<a name='db_rcu_sys_password'>

The sys password for the RCU check/install.


[Back to overview of db_rcu](#attributes)


### sys_user<a name='db_rcu_sys_user'>

The sys username for the RCU check/install.


[Back to overview of db_rcu](#attributes)

