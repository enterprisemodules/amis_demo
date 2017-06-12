---
title: ora_profile
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This resource allows you to manage a user profile in an Oracle database.

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ensure                    => 'present',
      composite_limit           => 'UNLIMITED',
      connect_time              => 'UNLIMITED',
      cpu_per_call              => 'UNLIMITED',
      cpu_per_session           => 'UNLIMITED',
      failed_login_attempts     => '10',
      idle_time                 => 'UNLIMITED',
      logical_reads_per_call    => 'UNLIMITED',
      logical_reads_per_session => 'UNLIMITED',
      password_grace_time       => '7',
      password_life_time        => '180',
      password_lock_time        => '1',
      password_reuse_max        => 'UNLIMITED',
      password_reuse_time       => 'UNLIMITED',
      password_verify_function  => 'NULL',
      private_sga               => 'UNLIMITED',
      sessions_per_user         => 'UNLIMITED',
      container                 => 'ALL'
    }

## Attributes



Attribute Name                                                      | Short Description                                                |
------------------------------------------------------------------- | ---------------------------------------------------------------- |
[composite_limit](#ora_profile_composite_limit)                     | Allows you set the composite_limit value in a profile.           |
[connect_time](#ora_profile_connect_time)                           | Allows you set the connect_time value in a profile.              |
[container](#ora_profile_container)                                 | Allows you to specify the scope of the object.                   |
[cpu_per_call](#ora_profile_cpu_per_call)                           | Allows you set the cpu_per_call value in a profile.              |
[cpu_per_session](#ora_profile_cpu_per_session)                     | Allows you set the cpu_per_session value in a profile.           |
[ensure](#ora_profile_ensure)                                       | The basic property that the resource should be in.               |
[failed_login_attempts](#ora_profile_failed_login_attempts)         | Allows you set the failed_login_attempts value in a profile.     |
[idle_time](#ora_profile_idle_time)                                 | Allows you set the idle_time value in a profile.                 |
[logical_reads_per_call](#ora_profile_logical_reads_per_call)       | Allows you set the logical_reads_per_call value in a profile.    |
[logical_reads_per_session](#ora_profile_logical_reads_per_session) | Allows you set the logical_reads_per_session value in a profile. |
[name](#ora_profile_name)                                           | The profile name
                                                |
[password_grace_time](#ora_profile_password_grace_time)             | Allows you set the password_grace_time value in a profile.       |
[password_life_time](#ora_profile_password_life_time)               | Allows you set the password_life_time value in a profile.        |
[password_lock_time](#ora_profile_password_lock_time)               | Allows you set the password_lock_time value in a profile.        |
[password_reuse_max](#ora_profile_password_reuse_max)               | Allows you set the password_reuse_max value in a profile.        |
[password_reuse_time](#ora_profile_password_reuse_time)             | Allows you set the password_reuse_time value in a profile.       |
[password_verify_function](#ora_profile_password_verify_function)   | Allows you set the password_verify_function value in a profile.  |
[private_sga](#ora_profile_private_sga)                             | Allows you set the private_sga value in a profile.               |
[profile_name](#ora_profile_profile_name)                           | The profile name
                                                |
[provider](#ora_profile_provider)                                   | resource.                                                        |
[sessions_per_user](#ora_profile_sessions_per_user)                 | Allows you set the sessions_per_user value in a profile.         |
[sid](#ora_profile_sid)                                             | SID to connect to.                                               |




### composite_limit<a name='ora_profile_composite_limit'>

Allows you set the composite_limit value in a profile.

Maximum weighted sum of: CPU_PER_SESSION, CONNECT_TIME,
LOGICAL_READS_PER_SESSION, and PRIVATE_SGA. If this limit is exceeded, Oracle aborts the session and returns an error.

composite_limit <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ensure                    => 'present',
        ...
      composite_limit           => 'UNLIMITED',
        ...
    }


[Back to overview of ora_profile](#attributes)


### connect_time<a name='ora_profile_connect_time'>

Allows you set the connect_time value in a profile.

Allowable connect time per session in minutes

connect_time <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      connect_time              => 'UNLIMITED',
      ...
    }


[Back to overview of ora_profile](#attributes)


### container<a name='ora_profile_container'>

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
[Back to overview of ora_profile](#attributes)


### cpu_per_call<a name='ora_profile_cpu_per_call'>

Allows you set the cpu_per_call value in a profile.

Maximum CPU time per call (100ths of a second)

cpu_per_call <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      cpu_per_call              => 'UNLIMITED',
      ...
    }


[Back to overview of ora_profile](#attributes)


### cpu_per_session<a name='ora_profile_cpu_per_session'>

Allows you set the cpu_per_session value in a profile.

Maximum CPU time per session (100ths of a second)

cpu_per_session <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      cpu_per_call              => 'UNLIMITED',
      ...
    }


[Back to overview of ora_profile](#attributes)


### ensure<a name='ora_profile_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_profile](#attributes)


### failed_login_attempts<a name='ora_profile_failed_login_attempts'>

Allows you set the failed_login_attempts value in a profile.

The number of failed attempts to log in to the user account before the account is locked

failed_login_attempts <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      failed_login_attempts     => '10',
      ...
    }


[Back to overview of ora_profile](#attributes)


### idle_time<a name='ora_profile_idle_time'>

Allows you set the idle_time value in a profile.

Allowed idle time before user is disconnected (minutes)

idle_time <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      idle_time                 => 'UNLIMITED',
      ...
    }


[Back to overview of ora_profile](#attributes)


### logical_reads_per_call<a name='ora_profile_logical_reads_per_call'>

Allows you set the logical_reads_per_call value in a profile.

Maximum number of database blocks read per call

logical_reads_per_call <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      logical_reads_per_call    => 'UNLIMITED',
      ...
    }


[Back to overview of ora_profile](#attributes)


### logical_reads_per_session<a name='ora_profile_logical_reads_per_session'>

Allows you set the logical_reads_per_session value in a profile.

Maximum number of database blocks read per session

logical_reads_per_session <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      logical_reads_per_session => 'UNLIMITED',
      ...
    }


[Back to overview of ora_profile](#attributes)


### name<a name='ora_profile_name'>

The profile name


[Back to overview of ora_profile](#attributes)


### password_grace_time<a name='ora_profile_password_grace_time'>

Allows you set the password_grace_time value in a profile.

The number of days after the grace period begins during which a
warning is issued and login is allowed. If the password is not
changed during the grace period, the password expires.

password_gracetime <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      password_grace_time       => '7',
      ...
    }


[Back to overview of ora_profile](#attributes)


### password_life_time<a name='ora_profile_password_life_time'>

Allows you set the password_life_time value in a profile.

The number of days the same password can be used for authentication

password_life_time <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      password_life_time        => '180',
      ...
    }


[Back to overview of ora_profile](#attributes)


### password_lock_time<a name='ora_profile_password_lock_time'>

Allows you set the password_lock_time value in a profile.

the number of days an account will be locked after the specified
number of consecutive failed login attempts defined by
FAILED_LOGIN_ATTEMPTS

password_lock_time <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      password_lock_time        => '1',
      ...
    }


[Back to overview of ora_profile](#attributes)


### password_reuse_max<a name='ora_profile_password_reuse_max'>

Allows you set the password_reuse_max value in a profile.
The number of times a password must be changed before it can be reused

password_reuse_max <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      password_reuse_max        => 'UNLIMITED',
      ...
    }


[Back to overview of ora_profile](#attributes)


### password_reuse_time<a name='ora_profile_password_reuse_time'>

Allows you set the password_reuse_time value in a profile.

The number of days between reuses of a password

password_reuse_time <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      password_reuse_time       => 'UNLIMITED',
      ...
    }


[Back to overview of ora_profile](#attributes)


### password_verify_function<a name='ora_profile_password_verify_function'>

Allows you set the password_verify_function value in a profile.

Verify passwords for length, content, and complexity

password_verify_function <function_name | NULL | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      password_verify_function  => 'NULL',
      ...
    }


[Back to overview of ora_profile](#attributes)


### private_sga<a name='ora_profile_private_sga'>

Allows you set the private_sga value in a profile.

Maximum integer bytes of private space in the SGA
(useful for systems using multi-threaded server MTS)

private_sga <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      private_sga               => 'UNLIMITED',
      ...
    }


[Back to overview of ora_profile](#attributes)


### profile_name<a name='ora_profile_profile_name'>

The profile name


[Back to overview of ora_profile](#attributes)


### provider<a name='ora_profile_provider'>

The specific backend to use for this `ora_profile`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage an Oracle profile in an Oracle Database via regular SQL


[Back to overview of ora_profile](#attributes)


### sessions_per_user<a name='ora_profile_sessions_per_user'>

Allows you set the sessions_per_user value in a profile.

Number of concurrent multiple sessions allowed per user

sessions_per_user <value | UNLIMITED | DEFAULT>

Here is an example on how to use this:

    ora_profile { 'DEFAULT@sid':
      ...
      sessions_per_user         => 'UNLIMITED'
      ...
    }


[Back to overview of ora_profile](#attributes)


### sid<a name='ora_profile_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_profile](#attributes)

