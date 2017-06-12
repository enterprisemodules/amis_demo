---
title: ora_thread
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This resource allows you to manage threads in an Oracle database.


This type allows you to enable a thread. Threads are used in Oracle RAC installations. This type is not very useful
for regular use, but it is used in the [Oracle RAC module](https://forge.puppetlabs.com/hajee/ora_rac).


    ora_thread{"2@sid":
      ensure  => 'enabled',
    }

This enables thread 2 on instance named `sid`

## Attributes



Attribute Name                             | Short Description              |
------------------------------------------ | ------------------------------ |
[ensure](#ora_thread_ensure)               | Whether the thread is enabled. |
[name](#ora_thread_name)                   | The full specfied thread name. |
[provider](#ora_thread_provider)           | resource.                      |
[sid](#ora_thread_sid)                     | SID to connect to.             |
[thread_number](#ora_thread_thread_number) | The thread number.             |




### ensure<a name='ora_thread_ensure'>

Whether the thread is enabled.

Valid values are `enabled`, `disabled`. 
[Back to overview of ora_thread](#attributes)


### name<a name='ora_thread_name'>

The full specfied thread name.


[Back to overview of ora_thread](#attributes)


### provider<a name='ora_thread_provider'>

The specific backend to use for this `ora_thread`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

simple
: Manage Oracle users in an Oracle Database via regular SQL


[Back to overview of ora_thread](#attributes)


### sid<a name='ora_thread_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_thread](#attributes)


### thread_number<a name='ora_thread_thread_number'>

The thread number.


[Back to overview of ora_thread](#attributes)

