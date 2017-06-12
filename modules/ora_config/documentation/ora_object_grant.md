---
title: ora_object_grant
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you to grant users rights to specified database objects.

To grant user `SCOTT` `execute` and `debug` rights on on the `sys.dbms_aqin` packgage, you can use:

    ora_object_grant{'SCOTT->sys.dbms_aqin@SID':
      permissions => ['execute', 'debug'],
    }

If you want to make sure the user only has `execute` rights, use:

    ora_object_grant{'OTHER_USER->sys.dbms_aqin@SID':
       permissions => ['execute'],
    }

If you want to make sure **no** permissions are granted, you can use an empty array like this:

    ora_object_grant{'OTHER_USER->sys.dbms_aqin':
       permissions => [],
    }

## Attributes



Attribute Name                                                     | Short Description                                                                                                 |
------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------- |
[container](#ora_object_grant_container)                           | Allows you to specify the scope of the object.                                                                    |
[grantee](#ora_object_grant_grantee)                               | The Oracle username that is granted (or revoked) the permission.                                                  |
[name](#ora_object_grant_name)                                     | The object and name combination you want to manage.                                                               |
[object_name](#ora_object_grant_object_name)                       | The object name.                                                                                                  |
[permissions](#ora_object_grant_permissions)                       | The permissions on the specfied object, granted to the specfied user.                                             |
[provider](#ora_object_grant_provider)                             | resource.                                                                                                         |
[sid](#ora_object_grant_sid)                                       | SID to connect to.                                                                                                |
[with_grant_permissions](#ora_object_grant_with_grant_permissions) | The permissions on the specfied object, granted to the specfied user with the option to regrant to an other user. |




### container<a name='ora_object_grant_container'>

Allows you to specify the scope of the object.

This property is only supported on version 12 and higher. It allows you to specify if the user
will be seen through all portable containers (e.g. global) of just in the current
pluggable database.

You can use `container` on:

- `ora_user`
- `ora_profile`
- `ora_object_grant`

Here is an example on how to use this:

    ora_... { '...@sid':
      ...
      container       => 'current',
      ...
    }

Valid values are `current`, `all`. 
[Back to overview of ora_object_grant](#attributes)


### grantee<a name='ora_object_grant_grantee'>

The Oracle username that is granted (or revoked) the permission.

This parameter is extracted from the title of the type. It is separated by the object by a `/`.

    ora_object_grant { 'SCOTT->sys.dbms_aqin@SID':
      ...
    }

In this example `SCOTT` is the grantee. Grantee names will always be uppercased by Puppet.
This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
case string.


[Back to overview of ora_object_grant](#attributes)


### name<a name='ora_object_grant_name'>

The object and name combination you want to manage. Including an appended SID.

    ora_object_grant { 'SCOTT->sys.dbms_aqin@SID':
      ...
    }

The SID is optional. When you don't specify an SID, Puppet will take the first ASM instance
from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
name (e.g. a name including the SID).


[Back to overview of ora_object_grant](#attributes)


### object_name<a name='ora_object_grant_object_name'>

The object name.

This parameter is extracted from the title of the type. It is the first part of the name.

    ora_object_grant { 'SCOTT->sys.dbms_aqin@SID':
      ...
    }

In this example `sys.dbms_aqin` is the object name. The object names will always be uppercased by Puppet.
This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
case string.

You must specify full qualified object names. This means `owner.object`.


[Back to overview of ora_object_grant](#attributes)


### permissions<a name='ora_object_grant_permissions'>

The permissions on the specfied object, granted to the specfied user.

This is a required array of rights to grant on the user object combination

    ora_object_grant{ ...:
      permissions => ['execute', 'select'],
    }

When this list contains less rights then currently granted, the the extra rights will
be revoked from the user. If the permissions list contains more rights then currently
granted in the database, the extra rights will be granted to the user.

If you want to make sure no rights are granted, you must use an empty array.

    ora_object_grant{ ...:
      permissions => ['execute', 'select'],
    }


[Back to overview of ora_object_grant](#attributes)


### provider<a name='ora_object_grant_provider'>

The specific backend to use for this `ora_object_grant`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

prefetching
: Manage Oracle object permissions via regular SQL


[Back to overview of ora_object_grant](#attributes)


### sid<a name='ora_object_grant_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_object_grant](#attributes)


### with_grant_permissions<a name='ora_object_grant_with_grant_permissions'>

The permissions on the specfied object, granted to the specfied user with the option to regrant to an other user.

This is a required array of rights to grant on the user object combination

    ora_object_grant{ ...:
      with_grant_permissions => ['execute', 'select'],
    }

When this list contains less rights then currently granted, the the extra rights will
be revoked from the user. If the permissions list contains more rights then currently
granted in the database, the extra rights will be granted to the user.

If you want to make sure no rights are granted, you must use an empty array.

    ora_object_grant{ ...:
      with_grant_permissions => ['execute', 'select'],
    }


[Back to overview of ora_object_grant](#attributes)

