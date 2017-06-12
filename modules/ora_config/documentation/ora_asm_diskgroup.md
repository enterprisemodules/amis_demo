---
title: ora_asm_diskgroup
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you to manage your ASM diskgroups.

Like the other Oracle types, you must specify the SID. But for this type it must be the ASM sid.
Most of the times, this is `+ASM1`

    ora_asm_diskgroup {'REDO@+ASM1':
      ensure          => 'present',
      redundancy_type => 'normal',
      compat_asm      => '11.2.0.0.0',
      compat_rdbms    => '11.2.0.0.0',
      disks           => {
        'FAILGROUP1' => [
          { 'diskname' => 'REDOVOL1', 'path' => 'ORCL:REDOVOL1'}
        ],
        'FAILGROUP2' => [
          { 'diskname' => 'REDOVOL2', 'path' => 'ORCL:REDOVOL2'},
        ]
      }
    }

## Attributes



Attribute Name                                            | Short Description                                                 |
--------------------------------------------------------- | ----------------------------------------------------------------- |
[allow_disk_update](#ora_asm_diskgroup_allow_disk_update) | When set to true, allow the puppet type to update the disks.      |
[asm_sid](#ora_asm_diskgroup_asm_sid)                     | ASM SID to connect to.                                            |
[au_size](#ora_asm_diskgroup_au_size)                     | The allocation unit size of the diskgroup in Mb.                  |
[compat_asm](#ora_asm_diskgroup_compat_asm)               | The compatible asm attribute of the diskgroup.                    |
[compat_rdbms](#ora_asm_diskgroup_compat_rdbms)           | The compatible rdbms attribute of the diskgroup.                  |
[diskgroup_state](#ora_asm_diskgroup_diskgroup_state)     | The state of the diskgroup.                                       |
[disks](#ora_asm_diskgroup_disks)                         | The disks in the diskgroup.                                       |
[ensure](#ora_asm_diskgroup_ensure)                       | The basic property that the resource should be in.                |
[force](#ora_asm_diskgroup_force)                         | Enable force diskmount when chaning the state of the diskgroup.,
 |
[groupname](#ora_asm_diskgroup_groupname)                 | The diskgroup name.                                               |
[name](#ora_asm_diskgroup_name)                           | The full diskgroup name including SID.                            |
[provider](#ora_asm_diskgroup_provider)                   | resource.                                                         |
[redundancy_type](#ora_asm_diskgroup_redundancy_type)     | The redundancy type of the diskgroup.                             |




### allow_disk_update<a name='ora_asm_diskgroup_allow_disk_update'>

When set to true, allow the puppet type to update the disks.

Changing this disks in an ASM diskgroup is a potentialy destructive operation. That is why
by default we disable this operation. If however this is required for your use case, you can set
the parameter to `true`. In that case, changes in the manifest will resuilt in changes beeing made to
the running system.

Here is an example:

    ora_asm_diskgroup {...:
      ...
      disks             = [....],
      allow_disk_update => true,
    }

This parameter only guards the disks property of the type. When changed in the manifest, all other
properties of `ora_asm_diskgroup` will be updated regardless of this setting.

Valid values are `true`, `false`. 
[Back to overview of ora_asm_diskgroup](#attributes)


### asm_sid<a name='ora_asm_diskgroup_asm_sid'>

ASM SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the ASM instance from the `/etc/ora_settings.yaml` with the name `default_asm`. We advise you to
either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_asm_diskgroup](#attributes)


### au_size<a name='ora_asm_diskgroup_au_size'>

The allocation unit size of the diskgroup in Mb.

    ora_asm_diskgroup { ...:
      ...
      au_size => 2,
    }

If you don't specify a value, Oracle will decide opn the default value. This is dependent on the
used Oracle and ASM version.

Valid values are `1`, `2`, `4`, `8`, `16`, `32`, `64`. 
[Back to overview of ora_asm_diskgroup](#attributes)


### compat_asm<a name='ora_asm_diskgroup_compat_asm'>

The compatible asm attribute of the diskgroup.

This specifies the ASM compatibility of the diskgroup. The valid values depend on the version of ASM and Oracle
you are using. At this point in time the next set of values are valid:

- `10.1`
- `11.2`
- `12.1`

Here is an example:

    ora_asm_diskgroup{ ...
      ...
      compat_asm => '11.2'
    }

When you don't specify a value, Oracle will decide the default value. Agin, the actual value depends on
the version of Oracle you are using. Check the Oracle documentation documentation of your version.


[Back to overview of ora_asm_diskgroup](#attributes)


### compat_rdbms<a name='ora_asm_diskgroup_compat_rdbms'>

The compatible rdbms attribute of the diskgroup.

This specifies the RDBMS compatibility of the diskgroup. The valid values depend on the version of ASM and Oracle
you are using. At this point in time the next set of values are valid:

- `10.1`
- `11.2`
- `12.1`

Here is an example:

    ora_asm_diskgroup{ ...
      ...
      compat_rdbms => '11.2'
    }

When you don't specify a value, Oracle will decide the default value. Agin, the actual value depends on
the version of Oracle you are using. Check the Oracle documentation documentation of your version.


[Back to overview of ora_asm_diskgroup](#attributes)


### diskgroup_state<a name='ora_asm_diskgroup_diskgroup_state'>

The state of the diskgroup.

This is an optional property. When you don't specify this value, the default value be `online`.

    ora_asm_diskgroup {...:
      ...
      diskgroup_state => 'mounted'
    }

When you want to force an unmount, use the `force` property:

    ora_asm_diskgroup {...:
      ...
      diskgroup_state => 'unmounted'
      force           => true,
    }

Valid values are `mounted`, `unmounted`, `MOUNTED`, `UNMOUNTED`. 
[Back to overview of ora_asm_diskgroup](#attributes)


### disks<a name='ora_asm_diskgroup_disks'>

The disks in the diskgroup.

The disks property is a required hash containing the disk and optionaly the failgroup information for this diskgroup.

The syntax used for this property depends on the value of the `redundancy_type`. When the `redundancy_type` is set to external,
no failgroups are used. In that case, the value for the `disks` property is an Array of Hashes, where every Hash contains
a `diskname` and a `path` key. Here is an example:

    ora_asm__diskgroup {...:
      redundancy_type => 'EXTERN',
      disks => [
          {diskname => 'RECODG_001', path => 'ORCL:RECODG_001'},
          {diskname => 'RECODG_002', path => 'ORCL:RECODG_002'},
        ],
      }
    }


When the `redundancy_type` is `NORMAL`, or `HIGH`, you *MUST* specfy the fail groups. The `disks` property is a Hash wjere the
key of the Hash is the name of the failgroup. The value of the Hash, is an Array of disks. A disk element is a Hash, where
every Hash contains a `diskname` and a `path` key. Here is an example:

    ora_asm__diskgroup {...:
      redundancy_type => 'NORMAL',
      disks => {
        FAILGROUP1 => [
          {diskname => 'RECODG_001', path => 'ORCL:RECODG_001'},
          {diskname => 'RECODG_002', path => 'ORCL:RECODG_002'},
        ],
        FAILGROUP2 => [
          {diskname => 'RECODG_003', path => 'ORCL:RECODG_003'},
          {diskname => 'RECODG_004', path => 'ORCL:RECODG_004'},
        ],
      }
    }


[Back to overview of ora_asm_diskgroup](#attributes)


### ensure<a name='ora_asm_diskgroup_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_asm_diskgroup](#attributes)


### force<a name='ora_asm_diskgroup_force'>

Enable force diskmount when chaning the state of the diskgroup.,

When you specify this when unmounting a diskgroup, ASM will force a dismount.

    ora_asm_diskgroup {...:
      ...
      diskgroup_state => 'UNMOUNTED'
      force           => true,
    }

Valid values are `true`, `false`. 
[Back to overview of ora_asm_diskgroup](#attributes)


### groupname<a name='ora_asm_diskgroup_groupname'>

The diskgroup name.

This is a required String parameter that is part of the title of the raw_resource.

    ora_asm_diskgroup { 'RECODG@+ASM1':
      ...
    }

In this example, the `RECODG` is de diskgroup name. Diskgroup names will always be uppercased by Puppet.
This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
case string.


[Back to overview of ora_asm_diskgroup](#attributes)


### name<a name='ora_asm_diskgroup_name'>

The full diskgroup name including SID.

The full diskgroup name contains a diskgroup and an SID.

    ora_asm_diskgroup { 'RECODG@+ASM1':
      ...
    }

The SID is optional. When you don't specify an SID, Puppet will take the first ASM instance
from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
name (e.g. a name including the SID).


[Back to overview of ora_asm_diskgroup](#attributes)


### provider<a name='ora_asm_diskgroup_provider'>

The specific backend to use for this `ora_asm_diskgroup`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage RAC ASM groups in an Oracle Database via regular SQL


[Back to overview of ora_asm_diskgroup](#attributes)


### redundancy_type<a name='ora_asm_diskgroup_redundancy_type'>

The redundancy type of the diskgroup.

This is a required string value. Here is an example:

    ora_asm_diskgroup {...:
      ...
      redundancy_type => 'NORMAL',
    }

Valid values are `HIGH`, `EXTERN` (also called `EXTERNAL`), `NORMAL`. 
[Back to overview of ora_asm_diskgroup](#attributes)

