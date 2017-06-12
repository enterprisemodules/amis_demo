---
title: db opatch
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

This is the Oracle Patch process called OPatch

## Attributes



Attribute Name                                                | Short Description                                |
------------------------------------------------------------- | ------------------------------------------------ |
[bundle_sub_patch_id](#db_opatch_bundle_sub_patch_id)         | One of the Sub patch number of the bundle patch
 |
[ensure](#db_opatch_ensure)                                   | Whether a patch should be applied.               |
[extracted_patch_dir](#db_opatch_extracted_patch_dir)         | The extracted patch folder.                      |
[name](#db_opatch_name)                                       | The name of the OPatch.                          |
[ocmrf_file](#db_opatch_ocmrf_file)                           | The ocmrf file.                                  |
[opatch_auto](#db_opatch_opatch_auto)                         | opatch auto bundle patch
                        |
[oracle_product_home_dir](#db_opatch_oracle_product_home_dir) | The oracle product home folder.                  |
[orainst_dir](#db_opatch_orainst_dir)                         | The orainst folder.                              |
[os_user](#db_opatch_os_user)                                 | The weblogic operating system user.              |
[patch_id](#db_opatch_patch_id)                               | The patchId of the OPatch.                       |
[provider](#db_opatch_provider)                               | resource.                                        |




### bundle_sub_patch_id<a name='db_opatch_bundle_sub_patch_id'>

One of the Sub patch number of the bundle patch


[Back to overview of db_opatch](#attributes)


### ensure<a name='db_opatch_ensure'>

Whether a patch should be applied.

Valid values are `present` (also called `installed`), `absent` (also called `purged`). 
[Back to overview of db_opatch](#attributes)


### extracted_patch_dir<a name='db_opatch_extracted_patch_dir'>

The extracted patch folder.


[Back to overview of db_opatch](#attributes)


### name<a name='db_opatch_name'>

The name of the OPatch.


[Back to overview of db_opatch](#attributes)


### ocmrf_file<a name='db_opatch_ocmrf_file'>

The ocmrf file.


[Back to overview of db_opatch](#attributes)


### opatch_auto<a name='db_opatch_opatch_auto'>

opatch auto bundle patch


[Back to overview of db_opatch](#attributes)


### oracle_product_home_dir<a name='db_opatch_oracle_product_home_dir'>

The oracle product home folder.


[Back to overview of db_opatch](#attributes)


### orainst_dir<a name='db_opatch_orainst_dir'>

The orainst folder.


[Back to overview of db_opatch](#attributes)


### os_user<a name='db_opatch_os_user'>

The weblogic operating system user.


[Back to overview of db_opatch](#attributes)


### patch_id<a name='db_opatch_patch_id'>

The patchId of the OPatch.


[Back to overview of db_opatch](#attributes)


### provider<a name='db_opatch_provider'>

The specific backend to use for this `db_opatch`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

db_opatch
: 


[Back to overview of db_opatch](#attributes)

