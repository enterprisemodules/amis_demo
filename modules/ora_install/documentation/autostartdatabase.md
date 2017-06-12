---
title: autostartdatabase
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

This defined type create's a startup script for the specified database and enables the service. The end result is that the named Oracle database is
restarted after a system restart.

Here is an example on how to use it:

``` puppet
ora_install::autostartdatabase{ 'autostart oracle':
  oracle_home             => '/oracle/product/12.1/db',
  user                    => 'oracle',
  db_name                 => 'test',
}

```



## Attributes



Attribute Name                                  | Short Description                                   |
----------------------------------------------- | --------------------------------------------------- |
[db_name](#autostartdatabase_db_name)           | The name of the database.                           |
[oracle_home](#autostartdatabase_oracle_home)   | The directory used as home for the Oracle database. |
[service_name](#autostartdatabase_service_name) | The service name to start.                          |
[user](#autostartdatabase_user)                 | The OS user used to start the database.             |




### db_name<a name='autostartdatabase_db_name'>

The name of the database.

[Back to overview of autostartdatabase](#attributes)


### oracle_home<a name='autostartdatabase_oracle_home'>

The directory used as home for the Oracle database.

[Back to overview of autostartdatabase](#attributes)


### service_name<a name='autostartdatabase_service_name'>

The service name to start.

[Back to overview of autostartdatabase](#attributes)


### user<a name='autostartdatabase_user'>

The OS user used to start the database.

[Back to overview of autostartdatabase](#attributes)

