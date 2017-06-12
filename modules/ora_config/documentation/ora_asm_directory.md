---
title: ora_asm_directory
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you to manage your ASM Directories.

Like the other Oracle types, it's not mandatory to specify a SID here.
In that case it will use the ora_setting entry for ASM with the `default` property set to `true`
If you do specify a SID it must be an ASM sid.
Most of the times, this is `+ASM`

    ora_asm_directory {'+DATA/DIR/SUBDIR@+ASM':
      ensure          => 'present',
      path            => '+DATA/DIR/SUBDIR'
    }

## Attributes



Attribute Name                          | Short Description                                  |
--------------------------------------- | -------------------------------------------------- |
[asm_path](#ora_asm_directory_asm_path) | The directory name.                                |
[asm_sid](#ora_asm_directory_asm_sid)   | ASM SID to connect to.                             |
[ensure](#ora_asm_directory_ensure)     | The basic property that the resource should be in. |
[name](#ora_asm_directory_name)         | The name of the ora_asm_directory including SID.   |
[provider](#ora_asm_directory_provider) | resource.                                          |
[recurse](#ora_asm_directory_recurse)   | automatically created.                             |




### asm_path<a name='ora_asm_directory_asm_path'>

The directory name.

This is a required String parameter that is part of the title of the raw_resource.

    ora_asm_directory { '+DATA/DIR/SUBDIR@+ASM1':
      ...
      asm_path    => '+DATA/DIR/SUBDIR',
      ...
    }

In this example, the `RECODG` is de diskgroup name. Diskgroup names will always be uppercased by Puppet.
This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
case string.


[Back to overview of ora_asm_directory](#attributes)


### asm_sid<a name='ora_asm_directory_asm_sid'>

ASM SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the ASM instance from the `/etc/ora_settings.yaml` with the name `default_asm`. We advise you to
either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_asm_directory](#attributes)


### ensure<a name='ora_asm_directory_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_asm_directory](#attributes)


### name<a name='ora_asm_directory_name'>

The name of the ora_asm_directory including SID.

    ora_asm_directory { '+DATA/DIR/SUBDIR@+ASM1':
      ...
    }

The SID is optional. When you don't specify an SID, Puppet will take the ASM instance from
ora_setting with property `default` set to true and use that as the SID. We recomend you to **always** use a full qualified
name (e.g. a name including the SID) or not do it at all.


[Back to overview of ora_asm_directory](#attributes)


### provider<a name='ora_asm_directory_provider'>

The specific backend to use for this `ora_asm_directory`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage ASM Directories in an Oracle Database via regular SQL


[Back to overview of ora_asm_directory](#attributes)


### recurse<a name='ora_asm_directory_recurse'>

When you set this value to true, this ASM directory and all parent directories will be
automatically created.

Valid values are `true`, `false`, `yes`, `no`, `true`, `false`. 
[Back to overview of ora_asm_directory](#attributes)

