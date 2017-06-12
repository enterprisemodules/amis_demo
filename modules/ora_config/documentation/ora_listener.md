---
title: ora_listener
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This manages the oracle listener process.

It makes sure the Oracle SQL*Net listener is running.

    ora_listener {'SID':
      ensure  => running,
      require => Exec['db_install_instance'],
    }

The name of the resource *MUST* be the sid for which you want to start the listener.

## Attributes



Attribute Name                     | Short Description                     |
---------------------------------- | ------------------------------------- |
[ensure](#ora_listener_ensure)     | Whether a listener should be running. |
[name](#ora_listener_name)         | The sid of the listner to run.        |
[provider](#ora_listener_provider) | resource.                             |




### ensure<a name='ora_listener_ensure'>

Whether a listener should be running.

This is a required property without any defaults.

Valid values are `stopped` (also called `false`), `running` (also called `true`). 
[Back to overview of ora_listener](#attributes)


### name<a name='ora_listener_name'>

The sid of the listner to run.


[Back to overview of ora_listener](#attributes)


### provider<a name='ora_listener_provider'>

The specific backend to use for this `ora_listener`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

listener
: 


[Back to overview of ora_listener](#attributes)

