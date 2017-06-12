---
title: ora_exec
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you run a specific SQL statement or an sql file on a specified instance sid.

    ora_exec{"drop table application_users@sid":
      username => 'app_user',
      password => 'password,'
    }

This statement will execute the sql statement `drop table application_users` on the instance names `instance`.

You can use the `unless` parameter to only execute the statement in certain states. If the query specified in the
`unless` parameter returns one or more records, the main statement is skipped.

    ora_exec{ "create synonym ${user}.${synonym} for USER.${synonym}":
      unless  => "select * from all_synonyms where owner='${user}' and synonym_name='${synonym}'",
    }

You can also execute a script.

    ora_exec{"@/tmp/do_some_stuff.sql@sid":
      username  => 'app_user',
      password  => 'password,'
      logoutput => on_failure,  # can be true, false or on_failure
    }

This statement will run the sqlscript `/tmp/do_some_stuff.sql` on the sid named `sid`. Use the `unless`
parameter to just execute the script in certain situations.

When you don't specify the username and the password, the type will connect as `sysdba`.

## Attributes



Attribute Name                           | Short Description                                           |
---------------------------------------- | ----------------------------------------------------------- |
[cwd](#ora_exec_cwd)                     |   The default directory from where the scripts will be run. |
[logoutput](#ora_exec_logoutput)         | exit code.                                                  |
[mark_as_error](#ora_exec_mark_as_error) | Additional error strings or regexes.                        |
[name](#ora_exec_name)                   | The full sql statement including a SID.                     |
[password](#ora_exec_password)           | The user's password.                                        |
[provider](#ora_exec_provider)           | resource.                                                   |
[refreshonly](#ora_exec_refreshonly)     | do the exec only when notfied.                              |
[report_errors](#ora_exec_report_errors) | Report any errors in the SQL scripts.                       |
[sid](#ora_exec_sid)                     | SID to connect to.                                          |
[statement](#ora_exec_statement)         | The sql command to execute.                                 |
[timeout](#ora_exec_timeout)             | Timeout for applying a resource in seconds.                 |
[unless](#ora_exec_unless)               | A query to determine if the ora_exec must execute or not.   |
[username](#ora_exec_username)           | The Oracle username the command will run in.                |




### cwd<a name='ora_exec_cwd'>

  The default directory from where the scripts will be run. If not specfied, this will be /tmp.

      ora_exec {...:
        ...
        cwd => '/opt/my_scripts'
      }

This parameter is convenient when the script you run, expects a default directory. For example
when running other scripts, without a specfied directory:

    @execute.sql


[Back to overview of ora_exec](#attributes)


### logoutput<a name='ora_exec_logoutput'>

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
[Back to overview of ora_exec](#attributes)


### mark_as_error<a name='ora_exec_mark_as_error'>

Additional error strings or regexes.

To decide whether an SQL action was successful or not, Puppet
scan's the output for specific strings indicating an error. Sometimes you want
full control over what is an error and what is not.

Using this parameter, you can do just that. When the string or regular expression you specify here, is found, `ora_exec` will signal an error.

  Here is an example:

      ora_exec{'@/tmp/my_script.sql':
        ...
        mark_as_error => /no such user/,
      }

  when your output contains the string `no such user`, an error will
  be raised.

  **WARNING**
  Using this parameter, all normal checks are discarded. So use
  this parameter with care


[Back to overview of ora_exec](#attributes)


### name<a name='ora_exec_name'>

The full sql statement including a SID.

    ora_exec { 'select * from tab@sid':
      ...
    }

The SID is optional. When you don't specify an SID, Puppet will take the first database instance
from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
name (e.g. a name including the SID).


[Back to overview of ora_exec](#attributes)


### password<a name='ora_exec_password'>

The user's password.


[Back to overview of ora_exec](#attributes)


### provider<a name='ora_exec_provider'>

The specific backend to use for this `ora_exec`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

sqlplus
: 


[Back to overview of ora_exec](#attributes)


### refreshonly<a name='ora_exec_refreshonly'>

do the exec only when notfied.

The command should only be run as a
refresh mechanism for when a dependent object is changed.  It only
makes sense to use this option when this command depends on some
other object; it is useful for triggering an action:

Note that only `subscribe` and `notify` can trigger actions, not `require`,
so it only makes sense to use `refreshonly` with `subscribe` or `notify`.

    ora_exec {...:
      ...
      refreshonly => true,
    }

The default value is `false`, meaning the SQL statement is executed as a normal part
of the Puppet catalog.

Valid values are `true`, `false`. 
[Back to overview of ora_exec](#attributes)


### report_errors<a name='ora_exec_report_errors'>

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
[Back to overview of ora_exec](#attributes)


### sid<a name='ora_exec_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_exec](#attributes)


### statement<a name='ora_exec_statement'>

The sql command to execute.

This is a required string value. The value must either contain a valid SQL statement:

    ora_exec { 'select * from tab@sid':
    }

or a valid script name.

    ora_exec { '@/tmp/valid_sql_script.sql@sid':
    }

when you don't specify a directory, Puppet will use the default directory specified in the
`cwd` parameter.

    ora_exec { '@valid_sql_script.sql@sid':
      ...
      cwd => '/tmp',
    }


[Back to overview of ora_exec](#attributes)


### timeout<a name='ora_exec_timeout'>

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


[Back to overview of ora_exec](#attributes)


### unless<a name='ora_exec_unless'>

A query to determine if the ora_exec must execute or not.

If the query returns something, either one or more rows, the ora_exec
is **NOT** executed. If the query returns no rows, the specified ora_exec
statement **IS** executed.

The unless clause **must** be a valid query. An error in the query will result in
a failure of the apply statement.

If you have specified a username and a password, the unless statement will be
executed in that context. E.g. logged in as the specfied user with the specfied
password.

The default value is empty. Meaning no unless statement is executed and the statement or script
specified in the title, will always be executed.

    ora_exec{ "create synonym ${user}.${synonym} for PRES.${synonym}":
      unless  => "select * from all_synonyms where owner='${user}' and synonym_name='${synonym}'",
    }


[Back to overview of ora_exec](#attributes)


### username<a name='ora_exec_username'>

The Oracle username the command will run in.

If none is specified, it will run as `sysdba`.

    ora_exec { ...:
      ...
      username => 'scott',
    }


[Back to overview of ora_exec](#attributes)

