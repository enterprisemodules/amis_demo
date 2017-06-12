---
title: resource_value
keywords: documentation
layout: documentation
sidebar: _sidebar
toc: false
---
## Overview

The type allows you to specify individual properties of native Puppet types as resources in a Puppet catalog.

This can be usefull when you need to add specific properties to an exsiting resource, but need to do it somewhere
else in your puppet code. Here is an contrived example:

     file {'/etc/a.a':
       ensure => 'present',
       group  => 'root',
     }

and in some other manifest:

    resource_value{ "File[/etc/a.a]owner":
      value => 'vagrant'
    }

here you add the `owner` property to the resource `File[/etc/a.a]`. When you run this manifest, you will only see
that the `File[/etc/a.a]` beeing managed once and all properties beeing set to the correct value.

By default the `resource_value` doesn't allow you to override the existing value. So this means when the value is
already set somewhere in the catalog. So when we try this example:

    file {'/etc/a.a':
      ensure => 'present',
      group  => 'root',
      owner  => 'root'
    }

    resource_value{ "File[/etc/a.a]owner":
      value => 'vagrant'
    }

This happens:

   Error: /Stage[main]/Main/Resource_value[File[/etc/a.a]owner]: Resource_value[File[/etc/a.a]owner]: Property owner value already defined on File[/etc/a.a] in catalog.
   Error: Failed to apply catalog: Some pre-run checks failed

When you want to override this behavior check the ` allow_redefine` parameter.

By default the `resource_value` type uses an existing resource in the catalog. When you try to use `resource_value` without
existing resource this happens:

   Error: /Stage[main]/Main/Resource_value[File[/etc/a.a]owner]: Resource_value[File[/etc/a.a]owner]: resource 'File[/etc/a.a]' not found in catalog
   Error: Failed to apply catalog: Some pre-run checks failed

When you want `resource_value` to create the resource, you have to set the `allow_create` property to true.

**WARNING**

The `resource_value` is a type that can be useful in specific cases. We have build it to support CIS benchmarks in Puppet. Our
use case was to allow the manifest writer to "just do his thing" and us to add the extra security layer. Without knowing to
much about each other. That said. Don't over use this type. Specially the `add_value` and the `remove_value` override existing
values without warning and searching for (logical) errors in your manifest becomes very difficult.

## Attributes



Attribute Name                                   | Short Description                                                       |
------------------------------------------------ | ----------------------------------------------------------------------- |
[add_value](#resource_value_add_value)           | The value you want to add to the array resource property.               |
[allow_create](#resource_value_allow_create)     | Allow creation of the resource if it is not yet in the catalog.         |
[allow_redefine](#resource_value_allow_redefine) | Allow redefinition of the property value.                               |
[name](#resource_value_name)                     | The full qualified name of the resource value you want to set.          |
[property_name](#resource_value_property_name)   | The property of the resource you want to manage.                        |
[provider](#resource_value_provider)             | resource.                                                               |
[remove_value](#resource_value_remove_value)     | The value you want to remove an entry from the array resource property. |
[resource_title](#resource_value_resource_title) | The title of the resource you want to manage.                           |
[resource_type](#resource_value_resource_type)   | The name of the type you want to manage.                                |
[unique](#resource_value_unique)                 |   The unique maker of the resource you want to manage.                  |
[value](#resource_value_value)                   | The actual value you want the resource property to be set to.           |




### add_value<a name='resource_value_add_value'>

The value you want to add to the array resource property.

Here is an example on how to use this:

    ora_user { 'USER@test':
      ensure               => 'present',
      default_tablespace   => 'USERS',
      grants               => ['ALTER SYSTEM', 'ALTER DATABASE'],
    }

Somewhere else in your manifest, you want to add an extra grant. You can do this like this:

    resource_value{'Ora_user[USER@test]grants/1':
      add_value => 'SELECT ANY DICTIONARY',
    }

The `add_value` property also supports an array value:

    resource_value{'Ora_user[USER@test]grants/more_grants':
      add_value => ['ALTER SESSION', 'CONNECT'],
    }


[Back to overview of resource_value](#attributes)


### allow_create<a name='resource_value_allow_create'>

Allow creation of the resource if it is not yet in the catalog.

By default the `resource_value` requires an existing entry in the catalog. When you
set `allow_create` to `true`, when the catalog doesn't contain the resource,
`resource_value` wil create it.

To allow this, the resource must allow a creation with just the specfied parameter name.


[Back to overview of resource_value](#attributes)


### allow_redefine<a name='resource_value_allow_redefine'>

Allow redefinition of the property value.

By default the `resource_value` doesn't allow you to override the value of a property. It
just allows the aditional definition of a property not yet defined.

When you set `allow_redefine` to `true`, this is allowed.

**WARNING** This must be used with great care. It might unkowningly redefine a property value.


[Back to overview of resource_value](#attributes)


### name<a name='resource_value_name'>

The full qualified name of the resource value you want to set. The full qualified name
contains:

- The type name (e.g. Host)
- The resource title (e.g. 'myhost.example.com')
- The property name (e.g. 'host_aliases')

When you want to work with array values, you can use the serial number

- The serial number (e.g. 1,2...etc)

Here is an example of a full qualified name:

    propery_value { 'Host[myhost.example.com]host_aliases/1':
      ...
    }


[Back to overview of resource_value](#attributes)


### property_name<a name='resource_value_property_name'>

The property of the resource you want to manage. It is the part after the `]`. In the next example:

    propery_value { 'File[/tmp/a.a]owner':
      ...
    }

`owner` is the property name.


[Back to overview of resource_value](#attributes)


### provider<a name='resource_value_provider'>

The specific backend to use for this `resource_value`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage individual properties as a full resource


[Back to overview of resource_value](#attributes)


### remove_value<a name='resource_value_remove_value'>

The value you want to remove an entry from the array resource property.

Here is an example on how to use this:

    ora_user { 'USER@test':
      ensure               => 'present',
      default_tablespace   => 'USERS',
      grants               => ['ALTER SYSTEM', 'ALTER DATABASE', 'SELECT ANY DICTIONARY', 'CONNECT'],
    }

Somewhere else in your manifest, you want to remove some of these grants. You can do this like this:

    resource_value{'Ora_user[USER@test]grants/1':
      remove_value => 'SELECT ANY DICTIONARY',
    }

The `remove_value` property also supports an array value:

    resource_value{'Ora_user[USER@test]grants/more_grants':
      remove_value => ['ALTER SESSION', 'CONNECT'],
    }


[Back to overview of resource_value](#attributes)


### resource_title<a name='resource_value_resource_title'>

The title of the resource you want to manage. It is the part between the `[` and the `]`. In the next example:

    propery_value { 'File[/tmp/a.a]owner':
      ...
    }

`/tmp/a.a` is the type name.


[Back to overview of resource_value](#attributes)


### resource_type<a name='resource_value_resource_type'>

The name of the type you want to manage. It is the first part of the title. In the next example:

    propery_value { 'File[/tmp/a.a]owner':
      ...
    }

`File` is the type name.


[Back to overview of resource_value](#attributes)


### unique<a name='resource_value_unique'>

  The unique maker of the resource you want to manage.

  When using the `add_value` or `remove_value` use cases, you might want to
  create multiple `resource_value` definitions on the same basic resource.
  Because Puppet mandates unique titles, we have added the possibility to add
  a unique maker to the end of the title. It has no other functional use than making
  the title unique. It is the last part of the title.

      propery_array_value { 'Host[www.example.com]host_aliases/1':
        ...
      }

  In this example the number 1 is the number that makes the title unique. But
  it doesn't have to be a number. It can also be s string.

  propery_array_value { 'Host[www.example.com]host_aliases/add_extra':
  ...
}


[Back to overview of resource_value](#attributes)


### value<a name='resource_value_value'>

The actual value you want the resource property to be set to.

In the next example, you want to set the property `owner` to the value `root`
for the file `/tmp/a.a`.

    propery_value { 'File[/tmp/a.a]owner':
      value => 'root'
    }


[Back to overview of resource_value](#attributes)

