---
title: ora_user
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you to manage a user inside an Oracle database.

It recognises most of the options that [CREATE USER](http://docs.oracle.com/cd/B28359_01/server.111/b28286/statements_8003.htm#SQLRF01503) supports. Besides these options, you can also use this type to manage the grants and the quota's for this user.

    ora_user{user_name@sid:
      temporary_tablespace      => temp,
      default_tablespace        => 'my_app_ts',
      password                  => 'verysecret',
      require                   => Ora_tablespace['my_app_ts'],
      grants                    => ['SELECT ANY TABLE', 'CONNECT', 'CREATE TABLE', 'CREATE TRIGGER'],
      quotas                    => {
                                      "my_app_ts"  => 'unlimited'
                                    },
    }

## Attributes



Attribute Name                                         | Short Description                                                                        |
------------------------------------------------------ | ---------------------------------------------------------------------------------------- |
[container](#ora_user_container)                       | Allows you to specify the scope of the object.                                           |
[create_only](#ora_user_create_only)                   | The attributes from `ora_user` you only want to manage when you create a user.           |
[default_roles](#ora_user_default_roles)               | The user's default roles
                                                                |
[default_tablespace](#ora_user_default_tablespace)     | The user's default tablespace.                                                           |
[ensure](#ora_user_ensure)                             | The basic property that the resource should be in.                                       |
[expired](#ora_user_expired)                           | specified if the account is expired.                                                     |
[granted](#ora_user_granted)                           | The grants you want to make sure are granted to the `ora_user` or `ora_role`.            |
[granted_with_admin](#ora_user_granted_with_admin)     | The grants with admin you want to make sure are granted to the `ora_user` or `ora_role`. |
[grants](#ora_user_grants)                             | grants for this user or role.                                                            |
[grants_with_admin](#ora_user_grants_with_admin)       | grants for this user or role.                                                            |
[locked](#ora_user_locked)                             | specified if the account is locked.                                                      |
[name](#ora_user_name)                                 | The user name.                                                                           |
[password](#ora_user_password)                         | The user's password.                                                                     |
[profile](#ora_user_profile)                           | The user's profile
                                                                      |
[provider](#ora_user_provider)                         | resource.                                                                                |
[quotas](#ora_user_quotas)                             | Quota's for this user.                                                                   |
[revoked](#ora_user_revoked)                           | The grants you want to make sure are revoked from the `ora_user` or `ora_role`.          |
[revoked_with_admin](#ora_user_revoked_with_admin)     | The grants you want to make sure are revoked from the `ora_user` or `ora_role`.          |
[sid](#ora_user_sid)                                   | SID to connect to.                                                                       |
[temporary_tablespace](#ora_user_temporary_tablespace) | The user's temporary tablespace.                                                         |
[username](#ora_user_username)                         | The user name.                                                                           |




### container<a name='ora_user_container'>

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
[Back to overview of ora_user](#attributes)


### create_only<a name='ora_user_create_only'>

The attributes from `ora_user` you only want to manage when you create a user.
This is usefull when defining oracle iser accounts for REAL users. Users that
are supposed to change the password and the account expirery.
Here is an example:

    ora_user {'scott':
      password    => 'secret',
      locked      => false,
      expired     => true,
      create_only => ['locked', 'expired', 'password']
    }

When user `scott` doesn't exists, it will be created as an expired account,
with specfied password. After the first run the properties `locked` `expired`
and `password` are not updated anymore. Even when there is a difference between
the manifest and reality.


[Back to overview of ora_user](#attributes)


### default_roles<a name='ora_user_default_roles'>

The user's default roles


[Back to overview of ora_user](#attributes)


### default_tablespace<a name='ora_user_default_tablespace'>

The user's default tablespace.


[Back to overview of ora_user](#attributes)


### ensure<a name='ora_user_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_user](#attributes)


### expired<a name='ora_user_expired'>

specified if the account is expired.

Valid values are `true`, `false`. 
[Back to overview of ora_user](#attributes)


### granted<a name='ora_user_granted'>

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


[Back to overview of ora_user](#attributes)


### granted_with_admin<a name='ora_user_granted_with_admin'>

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


[Back to overview of ora_user](#attributes)


### grants<a name='ora_user_grants'>

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


[Back to overview of ora_user](#attributes)


### grants_with_admin<a name='ora_user_grants_with_admin'>

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


[Back to overview of ora_user](#attributes)


### locked<a name='ora_user_locked'>

specified if the account is locked.

Valid values are `true`, `false`. 
[Back to overview of ora_user](#attributes)


### name<a name='ora_user_name'>

The user name.


[Back to overview of ora_user](#attributes)


### password<a name='ora_user_password'>

The user's password.


[Back to overview of ora_user](#attributes)


### profile<a name='ora_user_profile'>

The user's profile


[Back to overview of ora_user](#attributes)


### provider<a name='ora_user_provider'>

The specific backend to use for this `ora_user`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage Oracle users in an Oracle Database via regular SQL


[Back to overview of ora_user](#attributes)


### quotas<a name='ora_user_quotas'>

Quota's for this user.


[Back to overview of ora_user](#attributes)


### revoked<a name='ora_user_revoked'>

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


[Back to overview of ora_user](#attributes)


### revoked_with_admin<a name='ora_user_revoked_with_admin'>

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


[Back to overview of ora_user](#attributes)


### sid<a name='ora_user_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_user](#attributes)


### temporary_tablespace<a name='ora_user_temporary_tablespace'>

The user's temporary tablespace.


[Back to overview of ora_user](#attributes)


### username<a name='ora_user_username'>

The user name.


[Back to overview of ora_user](#attributes)

