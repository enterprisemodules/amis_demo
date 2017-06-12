---
title: ora_trigger
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This resource allows you to manage PL/SQL packages in the Oracle database.

    ora_trigger { 'testuser.my_trigger':
      ensure  => 'present',
      source => '/vagrant/tests/triger.sql',
    }

This puppet definition ensures that the trigger `testuser.my_trigger` is available
in the database and that its content matches the content defined in the specfied source.

To decide if the package needs an update, the puppet type compares the content in the database, with
the content in the source file. This comparison is done insenitive to case, white spacing and used quote's
(the " or the ` ).

When you have specfied `report_errors => true` (which is the default), the type will fail on PL/SQL
compilation errors. Packages with compilation errors do however end up in the database. On a second Puppet
run the won't be updated. Puppet reports a warning these resources though?

```
Warning: trigger TESTUSER.MY_TRIGGER@test up-to-date, but contains 4 error(s).
```

## Attributes



Attribute Name                              | Short Description                                                                          |
------------------------------------------- | ------------------------------------------------------------------------------------------ |
[cwd](#ora_trigger_cwd)                     |   The default directory from where the scripts will be run.                                |
[editionable](#ora_trigger_editionable)     | Whether to use the Edition-based redefinition (EBR) functionality of Oracle12c and higher. |
[ensure](#ora_trigger_ensure)               | The basic property that the resource should be in.                                         |
[logoutput](#ora_trigger_logoutput)         | exit code.                                                                                 |
[name](#ora_trigger_name)                   | The full trigger name including a SID.                                                     |
[owner](#ora_trigger_owner)                 | The owner of the package.                                                                  |
[provider](#ora_trigger_provider)           | resource.                                                                                  |
[report_errors](#ora_trigger_report_errors) | Report any errors in the SQL scripts.                                                      |
[sid](#ora_trigger_sid)                     | SID to connect to.                                                                         |
[source](#ora_trigger_source)               | A file describing the content of the trigger.                                              |
[timeout](#ora_trigger_timeout)             | Timeout for applying a resource in seconds.                                                |
[trigger_name](#ora_trigger_trigger_name)   | The name of the triggeryou want to manage.                                                 |




### cwd<a name='ora_trigger_cwd'>

  The default directory from where the scripts will be run. If not specfied, this will be /tmp.

      ora_exec {...:
        ...
        cwd => '/opt/my_scripts'
      }

This parameter is convenient when the script you run, expects a default directory. For example
when running other scripts, without a specfied directory:

    @execute.sql


[Back to overview of ora_trigger](#attributes)


### editionable<a name='ora_trigger_editionable'>


Whether to use the Edition-based redefinition (EBR) functionality of Oracle12c and higher.

When you specify a `true` value, Puppet will allow you to use create scripts with the
`EDITIONABLE` keyword in it. When comparing the actual value in the database with the value
in the specified creation script, this keyword must be specified for the puppet type to recognise they are the same.

    ora_package {...:
      ...
      editionable   => true,
      ...
    }

You can use this on both `ora_package` and `ora_trigger`.

When you specify a value of `false`, the `EDITIONABLE` keyword will be filtered before comparison. This is useful when you have scripts that need to work for a large range of Oracle versions.

The default value is `false`

Valid values are `true`, `false`. 
[Back to overview of ora_trigger](#attributes)


### ensure<a name='ora_trigger_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_trigger](#attributes)


### logoutput<a name='ora_trigger_logoutput'>

Whether to log command output in addition to logging the
exit code.  Defaults to `on_failure`, which only logs the output
when the command has an exit code that does not match any value
specified by the `returns` attribute. As with any resource type,
the log level can be controlled with the `loglevel` metaparameter.

    ora_exec {...:
      ...
      logoutput => true,
    }

The default value is `on_failure`

Valid values are `true`, `false`, `on_failure`. 
[Back to overview of ora_trigger](#attributes)


### name<a name='ora_trigger_name'>


The full trigger name including a SID.

    ora_trigger { 'owner.my_package@sid':
      ...
    }

The SID is optional. When you don't specify an SID, Puppet will take the first database instance
from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
name (e.g. a name including the SID).


[Back to overview of ora_trigger](#attributes)


### owner<a name='ora_trigger_owner'>

The owner of the package. This is the first part of the title string. The first part before
the `.`.

      ora_trigger { 'OWNER.TRIGGER@SID':
      	...
      }


[Back to overview of ora_trigger](#attributes)


### provider<a name='ora_trigger_provider'>

The specific backend to use for this `ora_trigger`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: This is the generic provider for a easy_type type


[Back to overview of ora_trigger](#attributes)


### report_errors<a name='ora_trigger_report_errors'>

Report any errors in the SQL scripts.

When you set this value to true, the type will report any errors that occur in the SQL statements or scripts
and stop processing. When you set it to `false`, it will ignore any SQL errors and just continue processing.
The default value is `true`, so it will stop processing when an SQL error is generated.

Here is an example:

    ora_exec{'delete from user_config':
      ...
      report_errors => true,

    }

Valid values are `true`, `false`. 
[Back to overview of ora_trigger](#attributes)


### sid<a name='ora_trigger_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_trigger](#attributes)


### source<a name='ora_trigger_source'>

A file describing the content of the trigger.

Because puppet uses the contents of this file to descide if something needs to be done, the
contents of this file must be very strict to the way Oracle stores the trigger in the database.

To decide if a change must be done, Puppet will fetch the trigger definition from the database and the contents
of the source. For both it will remove all:

- comments
- empty lines
- spaces
- newlines
- quotes

and do a comparisson.


[Back to overview of ora_trigger](#attributes)


### timeout<a name='ora_trigger_timeout'>

Timeout for applying a resource in seconds.

To be sure no Puppet operation, hangs a Puppet run, all operations have a timeout. When this timeout
expires, Puppet will abort the current operation and signal an error in the Puppet run.

With this parameter, you can specify the length of the timeout. The value is specified in seconds. In
this example, the `timeout`  is set to `600`  seconds.

    ora_type{ ...:
      ...
      timeout => 600,
    }

The default value for `timeout` is 300 seconds.


[Back to overview of ora_trigger](#attributes)


### trigger_name<a name='ora_trigger_trigger_name'>

The name of the triggeryou want to manage. The trigger name  is the second part of the
title.

    ora_trigger { 'owner.trigger_name@sid':
      ...
    }


[Back to overview of ora_trigger](#attributes)

