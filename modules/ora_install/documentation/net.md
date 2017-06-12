---
title: net
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

Installs and configures Oracle SQL*Net

This defined type allows you to install and configure Oracle SQL*net.

```puppet
ora_install::net{ 'config net8':
  oracle_home   => '/oracle/product/11.2/db',
  version       => '11.2',
  user          => 'oracle',
  group         => 'dba',
  download_dir  => '/install',
  db_port       => '1521', #optional
}
```




## Attributes



Attribute Name                    | Short Description                                                  |
--------------------------------- | ------------------------------------------------------------------ |
[db_port](#net_db_port)           | The IP port number to use for connecting to the database.          |
[download_dir](#net_download_dir) | The directory where the Puppet software puts all downloaded files. |
[group](#net_group)               | The os group to use for these Oracle puppet definitions.           |
[oracle_home](#net_oracle_home)   | A directory to be used as Oracle home directory for this software. |
[user](#net_user)                 | The user used for the specified installation.                      |
[version](#net_version)           | The version that is installed in the used Oracle home.             |




### db_port<a name='net_db_port'>

The IP port number to use for connecting to the database.

The default value is `1521`

[Back to overview of net](#attributes)


### download_dir<a name='net_download_dir'>

The directory where the Puppet software puts all downloaded files.

Before Puppet can actually use remote files, they must be downloaded first. Puppet uses this directory to put all files in.

The default value is `/install`

[Back to overview of net](#attributes)


### group<a name='net_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of net](#attributes)


### oracle_home<a name='net_oracle_home'>

A directory to be used as Oracle home directory for this software.

[Back to overview of net](#attributes)


### user<a name='net_user'>

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

[Back to overview of net](#attributes)


### version<a name='net_version'>

The version that is installed in the used Oracle home.

Puppet uses this value to decide on version specific actions.

[Back to overview of net](#attributes)

