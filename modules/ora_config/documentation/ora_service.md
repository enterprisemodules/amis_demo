---
title: ora_service
keywords: documentation
layout: documentation
sidebar: ora_config_sidebar
toc: false
---
## Overview

This resource allows you to manage a service in an Oracle database.

It has support for serices on single instance databases, but also supports
creating services on a RAC cluster.  Here is an example on setting a service
on a RAC cluster.

    ora_service { 'MYSERVICE.DEVELOPMENT.ORG@SID1':
      ensure              => 'present',
      aq_ha_notifications => 'false',
      clb_goal            => 'LONG',
      dtp                 => 'false',
      failover_delay      => '0',
      failover_method     => 'NONE',
      failover_retries    => '0',
      failover_type       => 'NONE',
      lb_advisory         => 'THROUGHPUT',
      management_policy   => 'AUTOMATIC',
      preferred_instances => ['O2DEVEL1'],
      server_pool         => ['O2DEVEL_STAM.DEVELOPMENT.ORG'],
      service_role        => 'PRIMARY',
      status              => 'running',
      taf_policy          => 'NONE',
    }

On a single instance Oracle database, most of the above options are ignored. So a simple version
of the manifest for such a database would be:

    ora_service { 'MYSERVICE.DEVELOPMENT.ORG@SID1':
      ensure              => 'present',
    }

`ora_service` doesn't manage the internal services created by Oracle.

## Attributes



Attribute Name                                          | Short Description                                                                                                        |
------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
[aq_ha_notifications](#ora_service_aq_ha_notifications) | Indicates whether AQ HA notifications should be enabled.                                                                 |
[available_instances](#ora_service_available_instances) | A list of instance names to activate the service on.                                                                     |
[clb_goal](#ora_service_clb_goal)                       | The load balancing goal to the service.                                                                                  |
[dtp](#ora_service_dtp)                                 | Distributed Transaction Processing settings for this service.                                                            |
[ensure](#ora_service_ensure)                           | The basic property that the resource should be in.                                                                       |
[failover_delay](#ora_service_failover_delay)           | For Application Continuity and TAF, when reconnecting after a failure, delay between each connection retry (in seconds). |
[failover_method](#ora_service_failover_method)         | Failover method for the services.                                                                                        |
[failover_retries](#ora_service_failover_retries)       | The number of failover retry attempts.                                                                                   |
[failover_type](#ora_service_failover_type)             | Failover type.                                                                                                           |
[lb_advisory](#ora_service_lb_advisory)                 | Goal for the Load Balancing Advisory.                                                                                    |
[management_policy](#ora_service_management_policy)     | Service management policy.                                                                                               |
[name](#ora_service_name)                               | 
                                                                                                                        |
[preferred_instances](#ora_service_preferred_instances) | A list of preferred instances on which the service runs when the database is administrator managed.                      |
[provider](#ora_service_provider)                       | resource.                                                                                                                |
[server_pool](#ora_service_server_pool)                 | The name of a server pool used when the database is policy managed.                                                      |
[service_name](#ora_service_service_name)               | The service name.                                                                                                        |
[service_role](#ora_service_service_role)               | The service role for the specfied services.                                                                              |
[sid](#ora_service_sid)                                 | SID to connect to.                                                                                                       |
[status](#ora_service_status)                           | The state of the service.                                                                                                |
[taf_policy](#ora_service_taf_policy)                   | Specfies the TAF policy specification (for administrator-managed databases only).                                        |




### aq_ha_notifications<a name='ora_service_aq_ha_notifications'>

Indicates whether AQ HA notifications should be enabled.

To enable FAN for OCI connections, set AQ HA Notifications to True. For Oracle Database 12c, FAN uses ONS (Oracle Notification Service).

Here is an exaple on how to use this:

    ora_service{'my_service':
      ...
      aq_ha_notifications => false,
      ...
    }

Puppet provides no default value. But Oracle might, depending on your version.

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.

Valid values are `true`, `false`. 
[Back to overview of ora_service](#attributes)


### available_instances<a name='ora_service_available_instances'>

A list of instance names to activate the service on.

Here is an example on how to use this:

    ora_service{'my_service':
      ...
      available_instances => ['SID1', 'SID2', 'SID3'],
      ...
    }

When an instance is specfied that does not or not yes exist in the cluster, Puppet will
ignore it.


[Back to overview of ora_service](#attributes)


### clb_goal<a name='ora_service_clb_goal'>

The load balancing goal to the service.

Here is an exaple on how to use this:

    ora_service{'my_service':
      ...
      clb_goal => 'SHORT',
      ...
    }

Puppet provides no default value. But Oracle might, depending on your version.

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.

Valid values are `SHORT`, `LONG`, `short`, `long`. 
[Back to overview of ora_service](#attributes)


### dtp<a name='ora_service_dtp'>

Distributed Transaction Processing settings for this service.

Here is an exaple on how to use this:

    ora_service{'my_service':
      ...
      dtp => false,
      ...
    }

Puppet provides no default value. But Oracle might, depending on your version.

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.

Valid values are `true`, `false`. 
[Back to overview of ora_service](#attributes)


### ensure<a name='ora_service_ensure'>

The basic property that the resource should be in.

Valid values are `present`, `absent`. 
[Back to overview of ora_service](#attributes)


### failover_delay<a name='ora_service_failover_delay'>

For Application Continuity and TAF, when reconnecting after a failure, delay between each connection retry (in seconds).

Here is an exaple on how to use this:

    ora_service{'my_service':
      ...
      failover_delay => 10,
      ...
    }

Puppet provides no default value. But Oracle might, depending on your version.

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.


[Back to overview of ora_service](#attributes)


### failover_method<a name='ora_service_failover_method'>

Failover method for the services.

Here is an exaple on how to use this:

    ora_service{'my_service':
      ...
      failover_method => 'BASIC',
      ...
    }

Puppet provides no default value. But Oracle might, depending on your version.

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.

Valid values are `NONE`, `BASIC`, `none`, `basic`. 
[Back to overview of ora_service](#attributes)


### failover_retries<a name='ora_service_failover_retries'>

The number of failover retry attempts.

Here is an exaple on how to use this:

    ora_service{'my_service':
      ...
      failover_retries => 3,
      ...
    }

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.


[Back to overview of ora_service](#attributes)


### failover_type<a name='ora_service_failover_type'>

Failover type.

Here is an example on how to use this:

    ora_service{'my_service':
      ...
      failover_type => 'SESSION',
      ...
    }

Puppet provides no default value. But Oracle might, depending on your version.

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.

Valid values are `NONE`, `SESSION`, `SELECT`, `none`, `session`, `select`. 
[Back to overview of ora_service](#attributes)


### lb_advisory<a name='ora_service_lb_advisory'>

Goal for the Load Balancing Advisory.

Here is an example on how to use this:

    ora_service{'my_service':
      ...
      lb_advisory => 'THROUGHPUT',
      ...
    }

Puppet provides no default value. But Oracle might, depending on your version.

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.

Valid values are `NONE`, `SERVICE_TIME`, `THROUGHPUT`, `none`, `service_time`, `throughput`. 
[Back to overview of ora_service](#attributes)


### management_policy<a name='ora_service_management_policy'>

Service management policy.

Here is an example on how to use this:

    ora_service{'my_service':
      ...
      management_policy => 'AUTOMATIC',
      ...
    }

Puppet provides no default value. But Oracle might, depending on your version.

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.

Valid values are `AUTOMATIC`, `MANUAL`, `automatic`, `manual`. 
[Back to overview of ora_service](#attributes)


### name<a name='ora_service_name'>




[Back to overview of ora_service](#attributes)


### preferred_instances<a name='ora_service_preferred_instances'>

A list of preferred instances on which the service runs when the database is administrator managed.

Here is an example on how to use this:

    ora_service{'my_service':
      ...
      prefered_instances => ['SID1', 'SID2'],
      ...
    }

When an instance is specfied that does not or not yes exist in the cluster, Puppet will
ignore it.

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.


[Back to overview of ora_service](#attributes)


### provider<a name='ora_service_provider'>

The specific backend to use for this `ora_service`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.Available providers are:

oracle11
: Manage Oracle services using srvctl syntax in Oracle 11 provider.

oracle12
: Manage Oracle services using srvctl syntax for Oracle 12


[Back to overview of ora_service](#attributes)


### server_pool<a name='ora_service_server_pool'>

The name of a server pool used when the database is policy managed.

Here is an example on how to use this:

    ora_service{'my_service':
      ...
      server_pool => ['pool1', 'pool2'],
      ...
    }

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.


[Back to overview of ora_service](#attributes)


### service_name<a name='ora_service_service_name'>

The service name.

The service name **MUST** be a full qualified name. e.g. a name containing a domain. For example:

    ora_service{'mydb.mydomain.com@sid':
      ensure => 'present',
    }


[Back to overview of ora_service](#attributes)


### service_role<a name='ora_service_service_role'>

The service role for the specfied services.

Here is an example on how to use this:

    ora_service{'my_service':
      ...
      service_role => 'PHYSICAL_STANDBY',
      ...
    }

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.

Valid values are `PRIMARY`, `PHYSICAL_STANDBY`, `LOGICAL_STANDBY`, `SNAPSHOT_STANDBY`, `primary`, `physical_standby`, `logical_standby`, `snapshot_standby`. 
[Back to overview of ora_service](#attributes)


### sid<a name='ora_service_sid'>

SID to connect to.

All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
We advise you to either use `@sid` in all your manifests or leave it empty everywhere.


[Back to overview of ora_service](#attributes)


### status<a name='ora_service_status'>

The state of the service. It can be either running or stopped.

Valid values are `running`, `stopped`. 
[Back to overview of ora_service](#attributes)


### taf_policy<a name='ora_service_taf_policy'>

Specfies the TAF policy specification (for administrator-managed databases only).

Here is an example on how you can use this:

    ora_service { 'new_service':
      ...
      taf_policy => 'basic',
      ...
    }

This is a cluster only property. On single node database this property will be ignored. If you use it,
Puppet will issue a warning.

Valid values are `BASIC`, `NONE`, `PRECONNECT`, `basic`, `none`, `preconnect`. 
[Back to overview of ora_service](#attributes)

