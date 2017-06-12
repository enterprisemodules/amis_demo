---
title: installdb
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

You can use this class to install a working oracle database on your system.

This defined type supports the following versions of Oracle:
- 11.2.0.1
- 11.2.0.3
- 11.2.0.4
- 12.1.0.1
- 12.1.0.2

## Example

Here is an example on how you can use this class to install an Oracle database
on your system.

```puppet
ora_install::installdb{ '12.1.0.2_Linux-x86-64':
  version                   => '12.1.0.2',
  file                      => 'V46095-01',
  database_type             => 'SE',
  oracle_base               => '/oracle',
  oracle_home               => '/oracle/product/12.1/db',
  bash_profile              => true,
  user                      => 'oracle',
  group                     => 'dba',
  group_install             => 'oinstall',
  group_oper                => 'oper',
  download_dir              => '/data/install',
  zip_extract               => true,
  puppet_download_mnt_point => $puppet_download_mnt_point,
}
```





## Attributes



Attribute Name                                                    | Short Description                                                     |
----------------------------------------------------------------- | --------------------------------------------------------------------- |
[bash_profile](#installdb_bash_profile)                           | Create a bash profile for the specified user or not.                  |
[cleanup_install_files](#installdb_cleanup_install_files)         | Cleanup extracted files after use.                                    |
[cluster_nodes](#installdb_cluster_nodes)                         | The names of the nodes in the RAC cluster.                            |
[create_user](#installdb_create_user)                             | Is a deprecated parameter.                                            |
[database_type](#installdb_database_type)                         | Selects the type of database you want to install.                     |
[download_dir](#installdb_download_dir)                           | The directory where the Puppet software puts all downloaded files.    |
[ee_optional_components](#installdb_ee_optional_components)       | This variable is used to enable or disable custom install.            |
[ee_options_selection](#installdb_ee_options_selection)           | List of Enterprise Edition Options you would like to install.         |
[file](#installdb_file)                                           | The source file to use.                                               |
[group](#installdb_group)                                         | The os group to use for these Oracle puppet definitions.              |
[group_install](#installdb_group_install)                         | The os group to use for installation.                                 |
[group_oper](#installdb_group_oper)                               | The OS group to allow operator rights.                                |
[is_rack_one_install](#installdb_is_rack_one_install)             | This variable is used to enable or disable RAC One Node install.      |
[ora_inventory_dir](#installdb_ora_inventory_dir)                 | The directory that contains the oracle inventory.                     |
[oracle_base](#installdb_oracle_base)                             | A directory to use as Oracle base directory.                          |
[oracle_home](#installdb_oracle_home)                             | A directory to be used as Oracle home directory for this software.    |
[puppet_download_mnt_point](#installdb_puppet_download_mnt_point) | The base path of all remote files for the defined type or class.      |
[remote_file](#installdb_remote_file)                             | The specified source file is a remote file or not.                    |
[temp_dir](#installdb_temp_dir)                                   | Directory to use for temporary files.                                 |
[user](#installdb_user)                                           | The user used for the specified installation.                         |
[user_base_dir](#installdb_user_base_dir)                         | The directory to use as base directory for the users.                 |
[version](#installdb_version)                                     | Specifies the version of the component you want to manage or install. |
[zip_extract](#installdb_zip_extract)                             | The specified source file is a zip file that needs te be extracted.   |




### database_type<a name='installdb_database_type'>

Selects the type of database you want to install.

At this point in time the following database types are supported and allowed:

- EE     : Enterprise Edition
- SE     : Standard Edition
- SEONE  : Standard Edition One

Here is an example using a local file specification:

```puppet
ora_install::....{...
  ...
  database_type => 'EE',
  ...
}
```

The default value for the parameter is `SE`

[Back to overview of installdb](#attributes)


### download_dir<a name='installdb_download_dir'>

The directory where the Puppet software puts all downloaded files.

Before Puppet can actually use remote files, they must be downloaded first. Puppet uses this directory to put all files in.

The default value is `/install`

[Back to overview of installdb](#attributes)


### bash_profile<a name='installdb_bash_profile'>

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

[Back to overview of installdb](#attributes)


### cleanup_install_files<a name='installdb_cleanup_install_files'>

Cleanup extracted files after use.

This is a boolean value. When you set this value to `true`. The installer class will
remove all extracted zip files after it has done its work.

The default value is `true`

Here is an example:

```puppet
ora_install::....{...
  ...
  cleanup_install_files => false,  # Keep all unzipped files
  ...
}
```

[Back to overview of installdb](#attributes)


### cluster_nodes<a name='installdb_cluster_nodes'>

The names of the nodes in the RAC cluster.

Here is an example on how to use this:

```puppet
installasm{'asm12':
  ...
  cluster_nodes => ['db1', 'db2']
  ...
}
```

[Back to overview of installdb](#attributes)


### create_user<a name='installdb_create_user'>

Is a deprecated parameter.

This parameter is deprecated. 

[Back to overview of installdb](#attributes)


### ee_optional_components<a name='installdb_ee_optional_components'>

This variable is used to enable or disable custom install.

When its is set to  true, the attribute `ee_options_selection` is used. When this value is false, the attribute `ee_options_selection` is ignored.

[Back to overview of installdb](#attributes)


### ee_options_selection<a name='installdb_ee_options_selection'>

List of Enterprise Edition Options you would like to install.

Check the oracle documentation what values are valid.

[Back to overview of installdb](#attributes)


### file<a name='installdb_file'>

The source file to use.

[Back to overview of installdb](#attributes)


### group<a name='installdb_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of installdb](#attributes)


### group_install<a name='installdb_group_install'>

The os group to use for installation.

The default is `oinstall`

[Back to overview of installdb](#attributes)


### group_oper<a name='installdb_group_oper'>

The OS group to allow operator rights.

The default is `oper`

[Back to overview of installdb](#attributes)


### is_rack_one_install<a name='installdb_is_rack_one_install'>

This variable is used to enable or disable RAC One Node install.

- true  : Value of RAC One Node service name is used.
- false : Value of RAC One Node service name is not used.

The default value is `false`

[Back to overview of installdb](#attributes)


### ora_inventory_dir<a name='installdb_ora_inventory_dir'>

The directory that contains the oracle inventory.

The default value is: `oracle_base/oraInventory`.

[Back to overview of installdb](#attributes)


### oracle_base<a name='installdb_oracle_base'>

A directory to use as Oracle base directory.

[Back to overview of installdb](#attributes)


### oracle_home<a name='installdb_oracle_home'>

A directory to be used as Oracle home directory for this software.

[Back to overview of installdb](#attributes)


### puppet_download_mnt_point<a name='installdb_puppet_download_mnt_point'>

The base path of all remote files for the defined type or class.

The default value is `puppet:///modules/ora_install`.

[Back to overview of installdb](#attributes)


### remote_file<a name='installdb_remote_file'>

The specified source file is a remote file or not.

Default value is `true`.

[Back to overview of installdb](#attributes)


### temp_dir<a name='installdb_temp_dir'>

Directory to use for temporary files.

[Back to overview of installdb](#attributes)


### user<a name='installdb_user'>

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

[Back to overview of installdb](#attributes)


### user_base_dir<a name='installdb_user_base_dir'>

The directory to use as base directory for the users.

[Back to overview of installdb](#attributes)


### version<a name='installdb_version'>

Specifies the version of the component you want to manage or install.

At this point in type we support the installation of:

- 11.2.0.1
- 11.2.0.3
- 11.2.0.4
- 12.1.0.1
- 12.1.0.2

Here is an example on how to specify the version:

```puppet
ora_install::....{...
  ...
  version => '12.1.0.2',
  ...
}
```

[Back to overview of installdb](#attributes)


### zip_extract<a name='installdb_zip_extract'>

The specified source file is a zip file that needs te be extracted.

default value is `true`.

When you specify a value of false, the source attribute must contain a reference to a directory instead of a zip file. 

[Back to overview of installdb](#attributes)

