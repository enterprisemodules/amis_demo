---
title: client
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

Installs the Oracle client software.

Using this defined type you can install the Oracle client software on your system.

Here is an example on how to use it:

```puppet
ora_install::client{ '12.1.0.1_Linux-x86-64':
  version                   => '12.1.0.1',
  file                      => 'linuxamd64_12c_client.zip',
  oracle_base               => '/oracle',
  oracle_home               => '/oracle/product/12.1/client',
  user                      => 'oracle',
  group                     => 'dba',
  group_install             => 'oinstall',
  download_dir              => '/install',
  bash_profile              => true,
  remote_file               => true,
  puppet_download_mnt_point => "puppet:///modules/oradb/",
  logoutput                 => true,
}
```

### support for multiple versions

This defined type has support for installing different versions of the client software on your system. In order to do this use the defined type multiple times in you manifest and use a different `oracle_home` and a different `file`.




## Attributes



Attribute Name                                                 | Short Description                                                  |
-------------------------------------------------------------- | ------------------------------------------------------------------ |
[bash_profile](#client_bash_profile)                           | Create a bash profile for the specified user or not.               |
[db_port](#client_db_port)                                     | The IP port to use for database communication.                     |
[download_dir](#client_download_dir)                           | The directory where the Puppet software puts all downloaded files. |
[file](#client_file)                                           | The source file to use.                                            |
[group](#client_group)                                         | The os group to use for these Oracle puppet definitions.           |
[group_install](#client_group_install)                         | The os group to use for installation.                              |
[logoutput](#client_logoutput)                                 | log the outputs of Puppet exec or not.                             |
[oracle_base](#client_oracle_base)                             | A directory to use as Oracle base directory.                       |
[oracle_home](#client_oracle_home)                             | A directory to be used as Oracle home directory for this software. |
[puppet_download_mnt_point](#client_puppet_download_mnt_point) | The base path of all remote files for the defined type or class.   |
[remote_file](#client_remote_file)                             | The specified source file is a remote file or not.                 |
[temp_dir](#client_temp_dir)                                   | Directory to use for temporary files.                              |
[user](#client_user)                                           | The user used for the specified installation.                      |
[user_base_dir](#client_user_base_dir)                         | The directory to use as base directory for the users.              |
[version](#client_version)                                     | The version that is installed in the used Oracle home.             |




### bash_profile<a name='client_bash_profile'>

Create a bash profile for the specified user or not.

Valid values are `true` and `false`.

When you specify a `true` for the parameter, Puppet will create a standard bash profile for the specified user. The bash profile will be placed in a directory named `user_base_dir/user`.

```puppet
ora_install::client { 'Oracle client':
  ...
  bash_profile  => true,
  user          => 'oracle',
  user_base_dir => '/home',
  ...
}
```

This snippet will create a bash profile called `/home/oracle/.bash_profile`.

[Back to overview of client](#attributes)


### db_port<a name='client_db_port'>

The IP port to use for database communication.

The default is 1521.

[Back to overview of client](#attributes)


### download_dir<a name='client_download_dir'>

The directory where the Puppet software puts all downloaded files.

Before Puppet can actually use remote files, they must be downloaded first. Puppet uses this directory to put all files in.

The default value is `/install`

[Back to overview of client](#attributes)


### file<a name='client_file'>

The source file to use.

[Back to overview of client](#attributes)


### group<a name='client_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of client](#attributes)


### group_install<a name='client_group_install'>

The os group to use for installation.

The default is `oinstall`

[Back to overview of client](#attributes)


### logoutput<a name='client_logoutput'>

log the outputs of Puppet exec or not.

When you specify `true` Puppet will log all output of `exec` types.

[Back to overview of client](#attributes)


### oracle_base<a name='client_oracle_base'>

A directory to use as Oracle base directory.

[Back to overview of client](#attributes)


### oracle_home<a name='client_oracle_home'>

A directory to be used as Oracle home directory for this software.

[Back to overview of client](#attributes)


### puppet_download_mnt_point<a name='client_puppet_download_mnt_point'>

The base path of all remote files for the defined type or class.

The default value is `puppet:///modules/ora_install`.

[Back to overview of client](#attributes)


### remote_file<a name='client_remote_file'>

The specified source file is a remote file or not.

Default value is `true`.

[Back to overview of client](#attributes)


### temp_dir<a name='client_temp_dir'>

Directory to use for temporary files.

[Back to overview of client](#attributes)


### user<a name='client_user'>

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

[Back to overview of client](#attributes)


### user_base_dir<a name='client_user_base_dir'>

The directory to use as base directory for the users.

[Back to overview of client](#attributes)


### version<a name='client_version'>

The version that is installed in the used Oracle home.

Puppet uses this value to decide on version specific actions.

[Back to overview of client](#attributes)

