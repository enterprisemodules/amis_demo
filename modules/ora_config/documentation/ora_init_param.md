---
title: ora_init_param
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This resource allows you to manage Oracle parameters.

this type allows you to manage your init.ora parameters. You can manage your `spfile` parameters and your `memory`
parameters. First the easy variant where you want to change an spfile parameter on your current sid for your current sid.

    ora_init_param{'SPFILE/PARAMETER':
      ensure  => present,
      value   => 'the_value'
    }

To manage the same parameter only the in-memory one, use:

    init_param{'MEMORY/PARAMETER':
      ensure  => present,
      value   => 'the_value'
    }

If you are running RAC and need to specify a parameter for an other instance, you can specify the instance as well.

    init_param{'MEMORY/PARAMETER:INSTANCE':
      ensure  => present,
      value   => 'the_value'
    }

Having more then one sid running on your node and you want to specify the sid you want to use, use `@SID` at the end.

    init_param{'MEMORY/PARAMETER:INSTANCE@SID':
      ensure  => present,
      value   => 'the_value'
    }

## Attributes



Attribute Name                                   | Short Description                                  |
------------------------------------------------ | -------------------------------------------------- |
[ensure](#ora_init_param_ensure)                 | The basic property that the resource should be in. |
[for_sid](#ora_init_param_for_sid)               | The SID you want to set the parameter for.         |
[name](#ora_init_param_name)                     | The parameter name.                                |
[parameter_name](#ora_init_param_parameter_name) | The parameter name.                                |
[provider](#ora_init_param_provider)             | resource.                                          |
[scope](#ora_init_param_scope)                   | The scope of the change.                           |
[sid](#ora_init_param_sid)                       | SID to connect to.                                 |
[value](#ora_init_param_value)                   | The value or values of the parameter.              |




### ensure<a name='ora_init_param_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_init_param](#attributes)


### for_sid<a name='ora_init_param_for_sid'>

The SID you want to set the parameter for.


[Back to overview of ora_init_param](#attributes)


### name<a name='ora_init_param_name'>

The parameter name.


[Back to overview of ora_init_param](#attributes)


### parameter_name<a name='ora_init_param_parameter_name'>

The parameter name.


[Back to overview of ora_init_param](#attributes)


### provider<a name='ora_init_param_provider'>

The specific backend to use for this `ora_init_param`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage Oracle Instance Parameters in an Oracle Database via regular SQL


[Back to overview of ora_init_param](#attributes)


### scope<a name='ora_init_param_scope'>

The scope of the change.

Valid values are `SPFILE`, `MEMORY`, `spfile`, `memory`. 
[Back to overview of ora_init_param](#attributes)


### sid<a name='ora_init_param_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_init_param](#attributes)


### value<a name='ora_init_param_value'>

The value or values of the parameter.

You can use either a single value or an Array value. Although not strictly required, we
reccomend that you alsways use quoted values. Also when using nummeric or boolean values.


An example  using a boolean value:

    ora_init_param { ....:
      ...
      value  => 'FALSE',
    }

Here an example using an array of values:

    ora_init_param { ....:
      ...
      value  => ['RECODG', 'BACKUPDG', 'DATADG'],
    }

    ora_init_param { ...:
      ...
      value  => '1',
    }


[Back to overview of ora_init_param](#attributes)

