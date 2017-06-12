---
title: ora_statement_audit
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This type allows you to enable or disable auditing inside an Oracle Database.

## Attributes



Attribute Name                                    | Short Description                                  |
------------------------------------------------- | -------------------------------------------------- |
[audit_option](#ora_statement_audit_audit_option) | The audit option you want to enable or disable.    |
[ensure](#ora_statement_audit_ensure)             | The basic property that the resource should be in. |
[name](#ora_statement_audit_name)                 | The audit type including a SID.                    |
[provider](#ora_statement_audit_provider)         | resource.                                          |
[sid](#ora_statement_audit_sid)                   | SID to connect to.                                 |




### audit_option<a name='ora_statement_audit_audit_option'>

The audit option you want to enable or disable.

This is the first part of the full name. In this example:

    ora_audit { 'alter user@sid':
      ...
    }

the `audit_option` is `alter_user`


[Back to overview of ora_statement_audit](#attributes)


### ensure<a name='ora_statement_audit_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_statement_audit](#attributes)


### name<a name='ora_statement_audit_name'>

The audit type including a SID.

    ora_audit { 'alter user@sid':
      ...
    }

The SID is optional. When you don't specify an SID, Puppet will take the first database instance
from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
name (e.g. a name including the SID).


[Back to overview of ora_statement_audit](#attributes)


### provider<a name='ora_statement_audit_provider'>

The specific backend to use for this `ora_statement_audit`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage auditing in an Oracle Database via regular SQL


[Back to overview of ora_statement_audit](#attributes)


### sid<a name='ora_statement_audit_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_statement_audit](#attributes)

