---
title: ora_object_audit
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you to enable or disable auditing inside an Oracle Database.

Here is an example to set auditing on the `SYS.AUD$` table:

    ora_object_audit { 'SYS.AUD$@test':
      ensure            => 'present',
      alter_failure     => 'by_access',
      alter_success     => 'by_access',
      audit_failure     => 'by_access',
      audit_success     => 'by_access',
      comment_failure   => 'by_access',
      comment_success   => 'by_access',
      flashback_failure => 'by_access',
      flashback_success => 'by_access',
      grant_failure     => 'by_access',
      grant_success     => 'by_access',
      index_failure     => 'by_access',
      index_success     => 'by_access',
      insert_failure    => 'by_access',
      insert_success    => 'by_access',
      lock_failure      => 'by_access',
      lock_success      => 'by_access',
      rename_failure    => 'by_access',
      rename_success    => 'by_access',
      select_failure    => 'by_access',
      select_success    => 'by_access',
      update_failure    => 'by_access',
      update_success    => 'by_access',
    }

Some audit options only apply to some types of database records. Specify only
those options that apply to the object you want to audit.

## Attributes



Attribute Name                                           | Short Description                                                                    |
-------------------------------------------------------- | ------------------------------------------------------------------------------------ |
[alter_failure](#ora_object_audit_alter_failure)         | Auditing option for the issuance of a failed ALTER operation on that object.         |
[alter_success](#ora_object_audit_alter_success)         | Auditing option for the issuance of a successful ALTER operation on that object.     |
[audit_failure](#ora_object_audit_audit_failure)         | Auditing option for the issuance of a failed AUDIT operation on that object.         |
[audit_success](#ora_object_audit_audit_success)         | Auditing option for the issuance of a successful AUDIT operation on that object.     |
[comment_failure](#ora_object_audit_comment_failure)     | Auditing option for the issuance of a failed COMMENT operation on that object.       |
[comment_success](#ora_object_audit_comment_success)     | Auditing option for the issuance of a successful COMMENT operation on that object.   |
[create_failure](#ora_object_audit_create_failure)       | Auditing option for the issuance of a failed CREATE operation on that object.        |
[create_success](#ora_object_audit_create_success)       | Auditing option for the issuance of a successful CREATE operation on that object.    |
[delete_failure](#ora_object_audit_delete_failure)       | Auditing option for the issuance of a failed DELETE operation on that object.        |
[delete_success](#ora_object_audit_delete_success)       | Auditing option for the issuance of a successful DELETE operation on that object.    |
[ensure](#ora_object_audit_ensure)                       | The basic property that the resource should be in.                                   |
[execute_failure](#ora_object_audit_execute_failure)     | Auditing option for the issuance of a failed EXECUTE operation on that object.       |
[execute_success](#ora_object_audit_execute_success)     | Auditing option for the issuance of a failed EXECUTE operation on that object.       |
[flashback_failure](#ora_object_audit_flashback_failure) | Auditing option for the issuance of a failed FLASHBACK operation on that object.     |
[flashback_success](#ora_object_audit_flashback_success) | Auditing option for the issuance of a successful FLASHBACK operation on that object. |
[grant_failure](#ora_object_audit_grant_failure)         | Auditing option for the issuance of a failed GRANT operation on that object.         |
[grant_success](#ora_object_audit_grant_success)         | Auditing option for the issuance of a successful GRANT operation on that object.     |
[index_failure](#ora_object_audit_index_failure)         | Auditing option for the issuance of a failed INDEX operation on that object.         |
[index_success](#ora_object_audit_index_success)         | Auditing option for the issuance of a successful INDEX operation on that object.     |
[insert_failure](#ora_object_audit_insert_failure)       | Auditing option for the issuance of a failed INSERT operation on that object.        |
[insert_success](#ora_object_audit_insert_success)       | Auditing option for the issuance of a successful INSERT operation on that object.    |
[lock_failure](#ora_object_audit_lock_failure)           | Auditing option for the issuance of a failed LOCK operation on that object.          |
[lock_success](#ora_object_audit_lock_success)           | Auditing option for the issuance of a successful LOCK operation on that object.      |
[name](#ora_object_audit_name)                           | The object and name combination you want to manage.                                  |
[object_name](#ora_object_audit_object_name)             | The object name.                                                                     |
[owner](#ora_object_audit_owner)                         | The owner of the table you want to audit.                                            |
[provider](#ora_object_audit_provider)                   | resource.                                                                            |
[read_failure](#ora_object_audit_read_failure)           | Auditing option for the issuance of a failed READ operation on that object.          |
[read_success](#ora_object_audit_read_success)           | Auditing option for the issuance of a successful READ operation on that object.      |
[rename_failure](#ora_object_audit_rename_failure)       | Auditing option for the issuance of a failed RENAME operation on that object.        |
[rename_success](#ora_object_audit_rename_success)       | Auditing option for the issuance of a successful RENAME operation on that object.    |
[select_failure](#ora_object_audit_select_failure)       | Auditing option for the issuance of a failed SELECT operation on that object.        |
[select_success](#ora_object_audit_select_success)       | Auditing option for the issuance of a successful SELECT operation on that object.    |
[sid](#ora_object_audit_sid)                             | SID to connect to.                                                                   |
[update_failure](#ora_object_audit_update_failure)       | Auditing option for the issuance of a failed UPDATE operation on that object.        |
[update_success](#ora_object_audit_update_success)       | Auditing option for the issuance of a successful UPDATE operation on that object.    |
[write_failure](#ora_object_audit_write_failure)         | Auditing option for the issuance of a failed WRITE operation on that object.         |
[write_success](#ora_object_audit_write_success)         | Auditing option for the issuance of a successful WRITE operation on that object.     |




### alter_failure<a name='ora_object_audit_alter_failure'>

Auditing option for the issuance of a failed ALTER operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      alter_failure => 'on_access',
      ...
    }

This enables the auditing of failed alters on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### alter_success<a name='ora_object_audit_alter_success'>

Auditing option for the issuance of a successful ALTER operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      alter_success => 'on_access',
      ...
    }

This enables the auditing of successful alters on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### audit_failure<a name='ora_object_audit_audit_failure'>

Auditing option for the issuance of a failed AUDIT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      audit_failure => 'on_access',
      ...
    }

This enables the auditing of failed audit operations on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### audit_success<a name='ora_object_audit_audit_success'>

Auditing option for the issuance of a successful AUDIT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      audit_success => 'on_access',
      ...
    }

This enables the auditing of successful audit operations on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### comment_failure<a name='ora_object_audit_comment_failure'>

Auditing option for the issuance of a failed COMMENT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      comment_failure => 'on_access',
      ...
    }

This enables the auditing of failed comments on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### comment_success<a name='ora_object_audit_comment_success'>

Auditing option for the issuance of a successful COMMENT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      comment_success=> 'on_access',
      ...
    }

This enables the auditing of successful comments on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### create_failure<a name='ora_object_audit_create_failure'>

Auditing option for the issuance of a failed CREATE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      create_failure => 'on_access',
      ...
    }

This enables the auditing of failed creates on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### create_success<a name='ora_object_audit_create_success'>

Auditing option for the issuance of a successful CREATE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure         => 'present',
      ...
      create_success => 'on_access',
      ...
    }

This enables the auditing of successful creates on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### delete_failure<a name='ora_object_audit_delete_failure'>

Auditing option for the issuance of a failed DELETE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      delete_failure => 'on_access',
      ...
    }

This enables the auditing of failed deletes on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### delete_success<a name='ora_object_audit_delete_success'>

Auditing option for the issuance of a successful DELETE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      delete_success => 'on_access',
      ...
    }

This enables the successful of failed deletes on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### ensure<a name='ora_object_audit_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`.
[Back to overview of ora_object_audit](#attributes)


### execute_failure<a name='ora_object_audit_execute_failure'>

Auditing option for the issuance of a failed EXECUTE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure          => 'present',
      ...
      execute_failure => 'on_access',
      ...
    }

This enables the auditing of failed executes on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### execute_success<a name='ora_object_audit_execute_success'>

Auditing option for the issuance of a failed EXECUTE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure          => 'present',
      ...
      execute_success => 'on_access',
      ...
    }

This enables the auditing of failed executes on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### flashback_failure<a name='ora_object_audit_flashback_failure'>

Auditing option for the issuance of a failed FLASHBACK operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      flashback_failure => 'on_access',
      ...
    }

This enables the auditing of failed flashbacks on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### flashback_success<a name='ora_object_audit_flashback_success'>

Auditing option for the issuance of a successful FLASHBACK operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure             => 'present',
      ...
      flashback_success  => 'on_access',
      ...
    }

This enables the auditing of successful flashbacks on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### grant_failure<a name='ora_object_audit_grant_failure'>

Auditing option for the issuance of a failed GRANT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      grant_failure => 'on_access',
      ...
    }

This enables the auditing of failed grants on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### grant_success<a name='ora_object_audit_grant_success'>

Auditing option for the issuance of a successful GRANT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      grant_success => 'on_access',
      ...
    }

This enables the auditing of successful grants on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### index_failure<a name='ora_object_audit_index_failure'>

Auditing option for the issuance of a failed INDEX operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      index_failure => 'on_access',
      ...
    }

This enables the auditing of failed indexes on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### index_success<a name='ora_object_audit_index_success'>

Auditing option for the issuance of a successful INDEX operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      index_success => 'on_access',
      ...
    }

This enables the auditing of successful indexes on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### insert_failure<a name='ora_object_audit_insert_failure'>

Auditing option for the issuance of a failed INSERT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      insert_failure => 'on_access',
      ...
    }

This enables the auditing of failed inserts on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### insert_success<a name='ora_object_audit_insert_success'>

Auditing option for the issuance of a successful INSERT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      insert_success => 'on_access',
      ...
    }

This enables the auditing of successful inserts on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### lock_failure<a name='ora_object_audit_lock_failure'>

Auditing option for the issuance of a failed LOCK operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      lock_failure => 'on_access',
      ...
    }

This enables the auditing of failed locks on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### lock_success<a name='ora_object_audit_lock_success'>

Auditing option for the issuance of a successful LOCK operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      lock_success => 'on_access',
      ...
    }

This enables the auditing of successful locks on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### name<a name='ora_object_audit_name'>

The object and name combination you want to manage. Including an appended SID.

    ora_object_audit { 'sys.dbms_aqin@SID':
      ...
    }

The SID is optional. When you don't specify an SID, Puppet will take the first ASM instance
from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
name (e.g. a name including the SID).


[Back to overview of ora_object_audit](#attributes)


### object_name<a name='ora_object_audit_object_name'>

The object name.

This parameter is extracted from the title of the type. It is the first part of the name.

    ora_object_audit { 'sys.dbms_aqin@SID':
      ...
    }

In this example `sys.dbms_aqin` is the object name. The object names will always be uppercased by Puppet.
This means in Puppet you can use either lower, upper or mixed case. In Oracle, it will be always be an upper
case string.

You must specify full qualified object names. This means `owner.object`.


[Back to overview of ora_object_audit](#attributes)


### owner<a name='ora_object_audit_owner'>

The owner of the table you want to audit. This is the first part of the title string. The first part before
the `.`.

      ora_object_audit { 'OWNER.TABLE@SID':
      	...
      }


[Back to overview of ora_object_audit](#attributes)


### provider<a name='ora_object_audit_provider'>

The specific backend to use for this `ora_object_audit`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage object auditing an Oracle Database via regular SQL


[Back to overview of ora_object_audit](#attributes)


### read_failure<a name='ora_object_audit_read_failure'>

Auditing option for the issuance of a failed READ operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      read_failure => 'on_access',
      ...
    }

This enables the auditing of failed reads on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### read_success<a name='ora_object_audit_read_success'>

Auditing option for the issuance of a successful READ operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      read_success => 'on_access',
      ...
    }

This enables the auditing of successful reads on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### rename_failure<a name='ora_object_audit_rename_failure'>

Auditing option for the issuance of a failed RENAME operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      rename_failure => 'on_access',
      ...
    }

This enables the auditing of failed renames on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### rename_success<a name='ora_object_audit_rename_success'>

Auditing option for the issuance of a successful RENAME operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      rename_success => 'on_access',
      ...
    }

This enables the auditing of successful renames on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### select_failure<a name='ora_object_audit_select_failure'>

Auditing option for the issuance of a failed SELECT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      select_failure => 'on_access',
      ...
    }

This enables the auditing of failed selects on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### select_success<a name='ora_object_audit_select_success'>

Auditing option for the issuance of a successful SELECT operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      select_success => 'on_access',
      ...
    }

This enables the auditing of successful selects on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### sid<a name='ora_object_audit_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_object_audit](#attributes)


### update_failure<a name='ora_object_audit_update_failure'>

Auditing option for the issuance of a failed UPDATE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      update_failure => 'on_access',
      ...
    }

This enables the auditing of failed updates on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### update_success<a name='ora_object_audit_update_success'>

Auditing option for the issuance of a successful UPDATE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      update_success => 'on_access',
      ...
    }

This enables the auditing of successful updates on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### write_failure<a name='ora_object_audit_write_failure'>

Auditing option for the issuance of a failed WRITE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      write_failure => 'on_access',
      ...
    }

This enables the auditing of failed writes on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)


### write_success<a name='ora_object_audit_write_success'>

Auditing option for the issuance of a successful WRITE operation on that object.

here is an example on how to use this:

    ora_object_audit { 'SYS.AUD$@test':
      ensure        => 'present',
      ...
      write_success => 'on_access',
      ...
    }

This enables the auditing of successful writes on the table `AUD$` from user `SYS`. An
audit record is written on every access.

Valid values are `none`, `by_access`, `by_session`.
[Back to overview of ora_object_audit](#attributes)
