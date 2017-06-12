---
title: ora opatch
keywords: documentation
layout: documentation
sidebar: _sidebar
toc: false
---
## Overview

This resource allows you to manage opatch patches on a specific database home.

## Attributes



Attribute Name                                                 | Short Description                                             |
-------------------------------------------------------------- | ------------------------------------------------------------- |
[comment](#ora_opatch_comment)                                 |    This property shows the text of the applied patches.       |
[ensure](#ora_opatch_ensure)                                   | The basic property that the resource should be in.            |
[name](#ora_opatch_name)                                       | The name
                                                     |
[ocmrf_file](#ora_opatch_ocmrf_file)                           | The ocmrf file.                                               |
[oracle_product_home_dir](#ora_opatch_oracle_product_home_dir) | The oracle product home folder.                               |
[orainst_dir](#ora_opatch_orainst_dir)                         | The orainst folder.                                           |
[patch_id](#ora_opatch_patch_id)                               | The patchId of the OPatch.                                    |
[provider](#ora_opatch_provider)                               | resource.                                                     |
[source](#ora_opatch_source)                                   | A source directory, but can also contain a zip or a tar file. |
[source_dir](#ora_opatch_source_dir)                           | The source folder in the zip to use.                          |
[sub_patches](#ora_opatch_sub_patches)                         | the sub patches you want to install.                          |
[tmp_dir](#ora_opatch_tmp_dir)                                 | The tmp extract directory of the patch.                       |




### comment<a name='ora_opatch_comment'>

   This property shows the text of the applied patches.

We noticed that the patch numbers are informational, but
the most important information is the textual representation
of the contents of the patch. Therefore, this type reports
this information when using `$ puppet resource ora_opatch`.
It is ignored when you apply a puppet manifest. You can still
use it in your manifest


[Back to overview of ora_opatch](#attributes)


### ensure<a name='ora_opatch_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_opatch](#attributes)


### name<a name='ora_opatch_name'>

The name


[Back to overview of ora_opatch](#attributes)


### ocmrf_file<a name='ora_opatch_ocmrf_file'>

The ocmrf file.

Valid values are:
- absent   (No ocmrf file is passed to opatch)
- standard (A standard ocmrf file is provided)
- a file name specification


[Back to overview of ora_opatch](#attributes)


### oracle_product_home_dir<a name='ora_opatch_oracle_product_home_dir'>

The oracle product home folder.


[Back to overview of ora_opatch](#attributes)


### orainst_dir<a name='ora_opatch_orainst_dir'>

The orainst folder.


[Back to overview of ora_opatch](#attributes)


### patch_id<a name='ora_opatch_patch_id'>

The patchId of the OPatch.


[Back to overview of ora_opatch](#attributes)


### provider<a name='ora_opatch_provider'>

The specific backend to use for this `ora_opatch`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

auto
: 

base
: Base provider for Oracle patches

opatchauto
: Use the new Opatchauto utility

regular
: Apply Oracle regular OPatches

  * Default for `id` == `root`.


[Back to overview of ora_opatch](#attributes)


### source<a name='ora_opatch_source'>

A source directory, but can also contain a zip or a tar file.

This parameter can contain the following types of values:

* `puppet:` URIs, which point to files in modules or Puppet file server
mount points.
* Fully qualified paths to locally available files (including files on NFS
shares or Windows mapped drives).
* `file:` URIs, which behave the same as local file paths.
* `http:` URIs, which point to files served by common web servers

The normal form of a `puppet:` URI is:

`puppet:///modules/<MODULE NAME>/<FILE PATH>`

This will fetch a file from a module on the Puppet master (or from a
local module when using Puppet apply). Given a `modulepath` of
`/etc/puppetlabs/code/modules`, the example above would resolve to
`/etc/puppetlabs/code/modules/<MODULE NAME>/files/<FILE PATH>`.

## Container file

When the file is a container file, it will automaticaly be extracted. At this point in
time the follwoing container types are supported:

- zip
- tar

## Compressed files

When the file is compressed, it will be uncompressed before beeing procesed further. This means that for example
a file `https://www.puppet.com/files/all.tar.gz` will be uncompressed before being unpackes with `tar`

## Examples

Here are some examples:

### Regular directories

    ... { '...':
      ...
      source  => '/home/software',
      ...
    }

The `/home/software` will be used by the custom type. Other Puppet code must make sure the directory contains the right files.

### A puppet url containing a zip file

    ... { '...':
      ...
      source  => 'puppet:///modules/software/software.zip',
      tmp_dir => '/tmp/mysoftware'
      ...
    }

The `software.zip` file will be fetched from the puppet server software module and put in `/tmp/mysoftware`, it will be unzipped and used for the actions
in the custom type. The file will be temporary put in


### A http url containing a tar file

... { '...':
  ...
  source  => 'http:///www.enterprisemodules.com/software/software.tar',
  tmp_dir => '/tmp/mysoftware'
  ...
}


The `software.tar` file will be fetched from the named web server and put in `/tmp/mysoftware`, it will be untarred and
used for the actions in the custom type.

### A file url fcontaining a compressed tar file

... { '...':
  ...
  source  => 'file:///nfsshare/software/software.tar.Z',
  tmp_dir => '/tmp/mysoftware'
  ...
}

The `software.tar.Z` file will be fetched from the namedd irectory, it will be uncompressed and then untarred on and put in `/tmp/mysoftware`
and used for the actions in the custom type.


[Back to overview of ora_opatch](#attributes)


### source_dir<a name='ora_opatch_source_dir'>

The source folder in the zip to use.

This parameter is only valid when you are using a source zip. It describes the folder in the zip to use as a base
for running the several Opatch utilities. When you don't specify a value, it
uses the patch_id.

example:

    ora_opatch{ "/app/grid/product/12.1/grid:21359755":
      ensure     => present,
      ...
      tmp_dir    => '/tmp/patches'
      source     => '/downloads/p21523260_121020_Linux-x86-64.zip',
      source_dir => '21523260',
    }

This will run the Opatch command on the folder `/tmp/patches/21523260'


[Back to overview of ora_opatch](#attributes)


### sub_patches<a name='ora_opatch_sub_patches'>

the sub patches you want to install.


[Back to overview of ora_opatch](#attributes)


### tmp_dir<a name='ora_opatch_tmp_dir'>

The tmp extract directory of the patch.


[Back to overview of ora_opatch](#attributes)

