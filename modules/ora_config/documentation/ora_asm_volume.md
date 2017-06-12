---
title: ora_asm_volume
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you to manage ASM volumes.

Here is an example on defining an ACFS volume:

    ora_asm_volume{diskgroup:my_volume@+ASM1":
      size          => '10G',
      volume_device => '/mnt/oravolume',
    }

Before you can issue this definition, the diskgroup must already exists.

## Attributes



Attribute Name                                 | Short Description                                           |
---------------------------------------------- | ----------------------------------------------------------- |
[asm_sid](#ora_asm_volume_asm_sid)             | ASM SID to connect to.                                      |
[diskgroup](#ora_asm_volume_diskgroup)         | The diskgroup into which we will create the volume.         |
[ensure](#ora_asm_volume_ensure)               | The basic property that the resource should be in.          |
[name](#ora_asm_volume_name)                   | The full asm volume name including  diskgroup name and SID. |
[provider](#ora_asm_volume_provider)           | resource.                                                   |
[size](#ora_asm_volume_size)                   | The size of the volume to ensure.                           |
[volume_device](#ora_asm_volume_volume_device) | The device the volume is created on.                        |
[volume_name](#ora_asm_volume_volume_name)     | The name of the volume to manage.                           |




### asm_sid<a name='ora_asm_volume_asm_sid'>

ASM SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the ASM instance from the `/etc/ora_settings.yaml` with the name `default_asm`. We advise you to
either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_asm_volume](#attributes)


### diskgroup<a name='ora_asm_volume_diskgroup'>

The diskgroup into which we will create the volume.

    ora_asm_volume { "recodg:my_volume@+ASM1":
      ...
    }


In this example, the `RECODG` is de diskgroup name. Diskgroup names will always be uppercased by Puppet.
This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
case string.


[Back to overview of ora_asm_volume](#attributes)


### ensure<a name='ora_asm_volume_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_asm_volume](#attributes)


### name<a name='ora_asm_volume_name'>

The full asm volume name including  diskgroup name and SID.

The full ASM volume nane name contains a diskgroup a volume name and an SID.

    ora_asm_volume { "diskgroup:my_volume@+ASM1":
      ...
    }

The SID is optional. When you don't specify an SID, Puppet will take the first ASM instance
from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
name (e.g. a name including the SID).


[Back to overview of ora_asm_volume](#attributes)


### provider<a name='ora_asm_volume_provider'>

The specific backend to use for this `ora_asm_volume`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

default_provider
: This is the generic provider for a easy_type type


[Back to overview of ora_asm_volume](#attributes)


### size<a name='ora_asm_volume_size'>

The size of the volume to ensure. The size is specified in Mb's.

This is a required property.

    ora_asm_volume { ...:
      ...
      size => '100M',
    }


[Back to overview of ora_asm_volume](#attributes)


### volume_device<a name='ora_asm_volume_volume_device'>

The device the volume is created on.

This required parameter must be a valid empry folder, the volume will be mounted on.

    ora_asm_volume { ...:
      ...
      volume_device => '/mnt/oravolume',
    }


[Back to overview of ora_asm_volume](#attributes)


### volume_name<a name='ora_asm_volume_volume_name'>

The name of the volume to manage.

    ora_asm_volume { "recodg:my_volume@+ASM1":
      ...
    }

In this example, the `my_colume` is de volume name. Volume names names will always be uppercased by Puppet.
This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
case string.


[Back to overview of ora_asm_volume](#attributes)

