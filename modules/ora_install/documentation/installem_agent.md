---
title: installem agent
keywords: documentation
layout: documentation
sidebar: ora_install_sidebar
toc: false
---
## Overview

Installs the Oracle Enterprise Manager Agent.

Here is an example:

```puppet
ora_install::installem{ 'em12104':
  version                     => '12.1.0.4',
  file                        => 'em12104_linux64',
  oracle_base_dir             => '/oracle',
  oracle_home_dir             => '/oracle/product/12.1/em',
  agent_base_dir              => '/oracle/product/12.1/agent',
  software_library_dir        => '/oracle/product/12.1/swlib',
  weblogic_user               => 'weblogic',
  weblogic_password           => 'Welcome01',
  database_hostname           => 'emdb.example.com',
  database_listener_port      => 1521,
  database_service_sid_name   => 'emrepos.example.com',
  database_sys_password       => 'Welcome01',
  sysman_password             => 'Welcome01',
  agent_registration_password => 'Welcome01',
  deployment_size             => 'SMALL',
  user                        => 'oracle',
  group                       => 'oinstall',
  download_dir                => '/install',
  zip_extract                 => true,
  puppet_download_mnt_point   => '/software',
  remote_file                 => false,
  log_output                  => true,
}
```




## Attributes



Attribute Name                                                              | Short Description                                                  |
--------------------------------------------------------------------------- | ------------------------------------------------------------------ |
[agent_base_dir](#installem_agent_agent_base_dir)                           | The directory to use as base for the agent software.               |
[agent_instance_home_dir](#installem_agent_agent_instance_home_dir)         | The directory to use as instance home.                             |
[agent_port](#installem_agent_agent_port)                                   | The IP port to use to for the agent.                               |
[agent_registration_password](#installem_agent_agent_registration_password) | The password to use to register the agent.                         |
[download_dir](#installem_agent_download_dir)                               | The directory where the Puppet software puts all downloaded files. |
[em_upload_port](#installem_agent_em_upload_port)                           | The port number of the HTTP port for the upload service.           |
[group](#installem_agent_group)                                             | The os group to use for these Oracle puppet definitions.           |
[install_platform](#installem_agent_install_platform)                       | The type of platform you want to install.                          |
[install_type](#installem_agent_install_type)                               | The type of install.                                               |
[install_version](#installem_agent_install_version)                         | The version you want to install.                                   |
[log_output](#installem_agent_log_output)                                   | log the outputs of Puppet exec or not.                             |
[oms_host](#installem_agent_oms_host)                                       | The OMS host to use.                                               |
[oms_port](#installem_agent_oms_port)                                       | The IP port to use for connecting to the OMS host.                 |
[ora_inventory_dir](#installem_agent_ora_inventory_dir)                     | The directory that contains the oracle inventory.                  |
[oracle_base_dir](#installem_agent_oracle_base_dir)                         | A directory to use as Oracle base directory.                       |
[source](#installem_agent_source)                                           | The source to use for the installation of the EM agent.            |
[sysman_password](#installem_agent_sysman_password)                         | The password to use for sysman.                                    |
[sysman_user](#installem_agent_sysman_user)                                 | The sysman user.                                                   |
[user](#installem_agent_user)                                               | The user used for the specified installation.                      |
[version](#installem_agent_version)                                         | The version that is installed in the used Oracle home.             |




### agent_base_dir<a name='installem_agent_agent_base_dir'>

The directory to use as base for the agent software.

[Back to overview of installem_agent](#attributes)


### agent_instance_home_dir<a name='installem_agent_agent_instance_home_dir'>

The directory to use as instance home.

[Back to overview of installem_agent](#attributes)


### agent_port<a name='installem_agent_agent_port'>

The IP port to use to for the agent.

The default value is `3872`

[Back to overview of installem_agent](#attributes)


### agent_registration_password<a name='installem_agent_agent_registration_password'>

The password to use to register the agent.

[Back to overview of installem_agent](#attributes)


### download_dir<a name='installem_agent_download_dir'>

The directory where the Puppet software puts all downloaded files.

Before Puppet can actually use remote files, they must be downloaded first. Puppet uses this directory to put all files in.

The default value is `/install`

[Back to overview of installem_agent](#attributes)


### em_upload_port<a name='installem_agent_em_upload_port'>

The port number of the HTTP port for the upload service.

The default value is: `1159`

[Back to overview of installem_agent](#attributes)


### group<a name='installem_agent_group'>

The os group to use for these Oracle puppet definitions.

The default is `dba`

[Back to overview of installem_agent](#attributes)


### install_platform<a name='installem_agent_install_platform'>

The type of platform you want to install.

The default value is `Linux x86-64`.

[Back to overview of installem_agent](#attributes)


### install_type<a name='installem_agent_install_type'>

The type of install.

valid values are:
- `undefined`
- `agentPull`
- `agentDeploy`

The default value is `undefined`

[Back to overview of installem_agent](#attributes)


### install_version<a name='installem_agent_install_version'>

The version you want to install.

The default value is `12.1.0.5.0`

[Back to overview of installem_agent](#attributes)


### log_output<a name='installem_agent_log_output'>

log the outputs of Puppet exec or not.

When you specify `true` Puppet will log all output of `exec` types. 

[Back to overview of installem_agent](#attributes)


### oms_host<a name='installem_agent_oms_host'>

The OMS host to use.

[Back to overview of installem_agent](#attributes)


### oms_port<a name='installem_agent_oms_port'>

The IP port to use for connecting to the OMS host.

[Back to overview of installem_agent](#attributes)


### ora_inventory_dir<a name='installem_agent_ora_inventory_dir'>

The directory that contains the oracle inventory.

The default value is: `oracle_base/oraInventory`.

[Back to overview of installem_agent](#attributes)


### oracle_base_dir<a name='installem_agent_oracle_base_dir'>

A directory to use as Oracle base directory.

[Back to overview of installem_agent](#attributes)


### source<a name='installem_agent_source'>

The source to use for the installation of the EM agent.

Valid values are:

- an URL like: `https://<OMS_HOST>:<OMS_PORT>/em/install/getAgentImage`
- a local file like: `/tmp/12.1.0.4.0_AgentCore_226_Linux_x64.zip`

[Back to overview of installem_agent](#attributes)


### sysman_password<a name='installem_agent_sysman_password'>

The password to use for sysman.

[Back to overview of installem_agent](#attributes)


### sysman_user<a name='installem_agent_sysman_user'>

The sysman user.

The default value is `sysman`.

[Back to overview of installem_agent](#attributes)


### user<a name='installem_agent_user'>

The user used for the specified installation.

The default value is `oracle`. The install class will not create the user for you. You must do that yourself.

Here is an example:

```puppet
ora_install::....{...
  ...
  user => 'my_oracle_user',
  ...
}
```

[Back to overview of installem_agent](#attributes)


### version<a name='installem_agent_version'>

The version that is installed in the used Oracle home.

Puppet uses this value to decide on version specific actions.

[Back to overview of installem_agent](#attributes)

