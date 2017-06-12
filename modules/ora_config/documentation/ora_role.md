---
title: ora_role
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you to create or delete a role inside an Oracle Database.

It recognises a limit part of the options that [CREATE ROLE](http://docs.oracle.com/cd/B28359_01/server.111/b28286/statements_6012.htm#SQLRF01311) supports.

    ora_role {'just_a_role@sid':
      ensure    => present,
    }

You can also add grants to a role:

    ora_role {'just_a_role@sid':
      ensure    => present,
      grants    => ['create session','create table'],
    }

## Attributes



Attribute Name                                     | Short Description                                                                        |
-------------------------------------------------- | ---------------------------------------------------------------------------------------- |
[container](#ora_role_container)                   | Allows you to specify the scope of the object.                                           |
[ensure](#ora_role_ensure)                         | The basic property that the resource should be in.                                       |
[granted](#ora_role_granted)                       | The grants you want to make sure are granted to the `ora_user` or `ora_role`.            |
[granted_with_admin](#ora_role_granted_with_admin) | The grants with admin you want to make sure are granted to the `ora_user` or `ora_role`. |
[grants](#ora_role_grants)                         | grants for this user or role.                                                            |
[grants_with_admin](#ora_role_grants_with_admin)   | grants for this user or role.                                                            |
[name](#ora_role_name)                             | The role name.                                                                           |
[password](#ora_role_password)                     | The password to use when connecting to to the database.                                  |
[provider](#ora_role_provider)                     | resource.                                                                                |
[revoked](#ora_role_revoked)                       | The grants you want to make sure are revoked from the `ora_user` or `ora_role`.          |
[revoked_with_admin](#ora_role_revoked_with_admin) | The grants you want to make sure are revoked from the `ora_user` or `ora_role`.          |
[role_name](#ora_role_role_name)                   | The role name.                                                                           |
[sid](#ora_role_sid)                               | SID to connect to.                                                                       |




### container<a name='ora_role_container'>

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
[Back to overview of ora_role](#attributes)


### ensure<a name='ora_role_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_role](#attributes)


### granted<a name='ora_role_granted'>

The grants you want to make sure are granted to the `ora_user` or `ora_role`. It is different from the
`grants` property in the sense that this is not a full list of the rights, but just the rights
that are granted to the user

Here is an example with an `ora_user`:

    ora_user {'scott':
      ...
      granted => ['GRANT ANY ROLE'],
      ...
    }

Here is an example with an `ora_role`:

    ora_role {'app_dba_role':
      ...
      granted => ['GRANT ANY ROLE'],
      ...
    }


This property is mutual exclusive with the `grants` property.


[Back to overview of ora_role](#attributes)


### granted_with_admin<a name='ora_role_granted_with_admin'>

The grants with admin you want to make sure are granted to the `ora_user` or `ora_role`. It is different from the
`grants_with_admin` property in the sense that this is not a full list of the rights, but just the rights
that are granted to the user

Here is an example with an `ora_user`:

    ora_user {'scott':
      ...
      granted_with_admin => ['GRANT ANY ROLE'],
      ...
    }

Here is an example with an `ora_role`:

    ora_role {'app_dba_role':
      ...
      granted_with_admin => ['GRANT ANY ROLE'],
      ...
    }


This property is mutual exclusive with the `grants` property.


[Back to overview of ora_role](#attributes)


### grants<a name='ora_role_grants'>

grants for this user or role.

All the grants this resource has. Here is an example on how to use this on an `ora_user`:

  ora_user { 'my_user@sid':
    ...
    grants => ['UNLIMITED TABLESPACE', 'CREATE PUBLIC SYNONYM'].
    ...
  }

Here is an example on how to use this on an `ora_role`:

  ora_ora_role { 'my_role@sid':
    ...
    grants => ['UNLIMITED TABLESPACE', 'CREATE PUBLIC SYNONYM'].
    ...
  }


[Back to overview of ora_role](#attributes)


### grants_with_admin<a name='ora_role_grants_with_admin'>

grants for this user or role.

All the grants this resource has. Here is an example on how to use this on an `ora_user`:

  ora_user { 'my_user@sid':
    ...
    grants_with_admin => ['UNLIMITED TABLESPACE', 'CREATE PUBLIC SYNONYM'].
    ...
  }

Here is an example on how to use this on an `ora_role`:

  ora_ora_role { 'my_role@sid':
    ...
    grants_with_admin => ['UNLIMITED TABLESPACE', 'CREATE PUBLIC SYNONYM'].
    ...
  }


[Back to overview of ora_role](#attributes)


### name<a name='ora_role_name'>

The role name.


[Back to overview of ora_role](#attributes)


### password<a name='ora_role_password'>

The password to use when connecting to to the database.


[Back to overview of ora_role](#attributes)


### provider<a name='ora_role_provider'>

The specific backend to use for this `ora_role`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage an Oracle role in an Oracle Database via regular SQL


[Back to overview of ora_role](#attributes)


### revoked<a name='ora_role_revoked'>

The grants you want to make sure are revoked from the `ora_user` or `ora_role`. It is different from the
`grants` property in the sense that this is not a full list of the rights, but just the rights
that are **NOT** granted to the user

Here is an example when using `ora_user`:

    ora_user {'scott':
      ...
      revoked => ['GRANT ANY ROLE'],
    }

Here is an example when using `ora_role`:

    ora_role {'scott':
      ...
      revoked => ['GRANT ANY ROLE'],
    }

This property is mutual exclusive with the `grants` property.


[Back to overview of ora_role](#attributes)


### revoked_with_admin<a name='ora_role_revoked_with_admin'>

The grants you want to make sure are revoked from the `ora_user` or `ora_role`. It is different from the
`grants` property in the sense that this is not a full list of the rights, but just the rights
that are **NOT** granted to the user

Here is an example when using `ora_user`:

    ora_user {'scott':
      ...
      revoked_with_admin => ['GRANT ANY ROLE'],
    }

Here is an example when using `ora_role`:

    ora_role {'scott':
      ...
      revoked_with_admin => ['GRANT ANY ROLE'],
    }

This property is mutual exclusive with the `grants` property.


[Back to overview of ora_role](#attributes)


### role_name<a name='ora_role_role_name'>

The role name.


[Back to overview of ora_role](#attributes)


### sid<a name='ora_role_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_role](#attributes)

