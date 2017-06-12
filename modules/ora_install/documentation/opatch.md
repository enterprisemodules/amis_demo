---
title: opatch
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

Wrapper defined type for installing patches. [DEPRECATED]

Please use[`ora_opatch`](TODO) to manage patches of your database software.

Here is an example on how to use this:

```puppet
ora_install::opatch{'19121551_db_patch':
  ensure                    => 'present',
  oracle_product_home       => hiera('oracle_home_dir'),
  patch_id                  => '19121551',
  patch_file                => 'p19121551_112040_Linux-x86-64.zip',
  user                      => hiera('oracle_os_user'),
  group                     => 'oinstall',
  download_dir              => hiera('oracle_download_dir'),
  ocmrf                     => true,
  require                   => Ora_install::Opatchupgrade['112000_opatch_upgrade_db'],
  puppet_download_mnt_point => hiera('oracle_source'),
}
```

This defined class is D



## Attributes



Attribute Name                                                 | Short Description                                                  |
-------------------------------------------------------------- | ------------------------------------------------------------------ |
[bundle_sub_folder](#opatch_bundle_sub_folder)                 | The folder in the zip file used for the specified patch.           |
[bundle_sub_patch_id](#opatch_bundle_sub_patch_id)             | The subid of the patch.                                            |
[clusterware](#opatch_clusterware)                             | When true use opatch auto.                                         |
[download_dir](#opatch_download_dir)                           | The directory where the Puppet software puts all downloaded files. |
[ensure](#opatch_ensure)                                       | State to obtain.                                                   |
[group](#opatch_group)                                         | The os group to use for these Oracle puppet definitions.           |
[ocmrf](#opatch_ocmrf)                                         | The OCMRF file to use.                                             |
[oracle_product_home](#opatch_oracle_product_home)             | The Oracle home to use.                                            |
[patch_file](#opatch_patch_file)                               | The name of the patch file.                                        |
[patch_id](#opatch_patch_id)                                   | The ID of the patch to apply.                                      |
[puppet_download_mnt_point](#opatch_puppet_download_mnt_point) | The base path of all remote files for the defined type or class.   |
[remote_file](#opatch_remote_file)                             | The specified source file is a remote file or not.                 |
[user](#opatch_user)                                           | The user used for the specified installation.                      |




### bundle_sub_folder<a name='opatch_bundle_sub_folder'>

The folder in the zip file used for the specified patch.

[Back to overview of opatch](#attributes)


### bundle_sub_patch_id<a name='opatch_bundle_sub_patch_id'>

The subid of the patch.

[Back to overview of opatch](#attributes)


### clusterware<a name='opatch_clusterware'>

When true use opatch auto.
Default value `false`

[Back to overview of opatch](#attributes)


### download_dir<a name='opatch_download_dir'>

The directory where the Puppet software puts all downloaded files.

Before Puppet can actually use remote files, they must be downloaded first. Puppet uses this directory to put all files in.

The default value is `/install`

[Back to overview of opatch](#attributes)


### ensure<a name='opatch_ensure'>

State to obtain.

The ensure attribute can be one of two values:

- present
- absent

When you specify `present`, Puppet will make sure the resource is available with all specified options and properties.

When the resource is already available(installed), and all attributes are as the are specified, Puppet will do nothing.

When you specify `absent`, Puppet will remove the resource if it is available. If it is not installed, Puppet will do nothing.

[Back to overview of opatch](#attributes)


### group<a name='opatch_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of opatch](#attributes)


### ocmrf<a name='opatch_ocmrf'>

The OCMRF file to use.

[Back to overview of opatch](#attributes)


### oracle_product_home<a name='opatch_oracle_product_home'>

The Oracle home to use.

[Back to overview of opatch](#attributes)


### patch_file<a name='opatch_patch_file'>

The name of the patch file.

[Back to overview of opatch](#attributes)


### patch_id<a name='opatch_patch_id'>

The ID of the patch to apply.

[Back to overview of opatch](#attributes)


### puppet_download_mnt_point<a name='opatch_puppet_download_mnt_point'>

The base path of all remote files for the defined type or class.

The default value is `puppet:///modules/ora_install`.

[Back to overview of opatch](#attributes)


### remote_file<a name='opatch_remote_file'>

The specified source file is a remote file or not.

Default value is `true`.

[Back to overview of opatch](#attributes)


### user<a name='opatch_user'>

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

[Back to overview of opatch](#attributes)

