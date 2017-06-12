---
title: ora_synonym
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This resource allows you to manage a synonym an Oracle database. You can create both
public synonyms or private synonyms. To create a public synonym use:

    ora_synonym { 'PUBLIC.SYNONYM_NAME@SID':
      ensure      => 'present',
      table_name  => 'TABLE_NAME',
      table_owner => 'TABLE_OWNER',
    }

To create a private synonym, you'll have to specfy the owner in the title:

    ora_synonym { 'OWNER.SYNONYM_NAME@SID':
      ensure      => 'present',
      table_name  => 'TABLE_NAME',
      table_owner => 'TABLE_OWNER',
    }

## Attributes



Attribute Name                            | Short Description                                  |
----------------------------------------- | -------------------------------------------------- |
[ensure](#ora_synonym_ensure)             | The basic property that the resource should be in. |
[name](#ora_synonym_name)                 | The synonym name
                                  |
[owner](#ora_synonym_owner)               | The owner of the synonym.                          |
[provider](#ora_synonym_provider)         | resource.                                          |
[sid](#ora_synonym_sid)                   | SID to connect to.                                 |
[synonym_name](#ora_synonym_synonym_name) | 	The synonym name.                                 |
[table_name](#ora_synonym_table_name)     |   The table name the synonym references.           |
[table_owner](#ora_synonym_table_owner)   |   The table owner the synonym references.          |




### ensure<a name='ora_synonym_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_synonym](#attributes)


### name<a name='ora_synonym_name'>

The synonym name


[Back to overview of ora_synonym](#attributes)


### owner<a name='ora_synonym_owner'>

The owner of the synonym. This is the first part of the title string. The first part before
the `.`.

        ora_synonym { 'OWNER.SYNONYM_NAME@SID':
        	...
        }


[Back to overview of ora_synonym](#attributes)


### provider<a name='ora_synonym_provider'>

The specific backend to use for this `ora_synonym`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

prefetching
: Manage Oracle synonyms in an Oracle Database via regular SQL


[Back to overview of ora_synonym](#attributes)


### sid<a name='ora_synonym_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_synonym](#attributes)


### synonym_name<a name='ora_synonym_synonym_name'>

	The synonym name. This is the part of the title between the `.` and the `@`

ora_synonym { 'PUBLIC.SYNONYM_NAME@SID':
	...
}


[Back to overview of ora_synonym](#attributes)


### table_name<a name='ora_synonym_table_name'>

  The table name the synonym references.

ora_synonym { 'PUBLIC.SYNONYM_NAME@SID':
	...
  table_name  => 'TABLE_NAME',
  ...
}


[Back to overview of ora_synonym](#attributes)


### table_owner<a name='ora_synonym_table_owner'>

  The table owner the synonym references.

ora_synonym { 'PUBLIC.SYNONYM_NAME@SID':
	...
  table_owner  => 'TABLE_OWNER',
  ...
}


[Back to overview of ora_synonym](#attributes)

