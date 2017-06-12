---
layout: documentation
title: Release Notes
keywords:
sidebar: ora_config_sidebar
toc: true
---

[`ora_config`](/shop/products/puppet-ora_config-module) version 2.3 is a major update. It contains many new features,  updates, and fixes.

## Support for container and pluggable databases

On of the most import things this release brings, is support for pluggable databases. The work horse of database creation [`ora_database`](/docs/ora_config/ora_database.html) has been updated to facilitate this. Now you can create a new container database as easy as:

```puppet
ora_database{'MY_CDB':
  ensure                  => present,
  ...
  container_database      => 'enabled',
  ...
}
```

Creating a pluggable database is also very easy. Again the [`ora_database`](/docs/ora_config/ora_database.html) type is enhanced to allow this. Here is an example:

```puppet
ora_database{'MY_PDB':
  ensure                  => present,
  contained_by            => 'MY_CDB',
  pdb_admin_user          => 'PDB_ADMIN',
  pdb_admin_password      => 'manager1234',
}
```

All custom types are now able to see all Oracle objects in both the `MY_CDB` database as well as in the `MY_PDB` database. Creating a user in the PDB can be done like this:

```puppet
ora_user { 'MY_USER@MY_PDB':
  ensure   => 'present'
  password => 'very_secret',
}
```

What is the difference? Nothing! Managing objects in a PDB is the same as managing objects in a regular database. Just like it is meant to be.

Check the [documentation](/docs/ora_config/ora_database.html) for all posibilities of [`ora_database`](/docs/ora_config/ora_database.html).

## Managing auditing

Version 2.3 of [`ora_config`](/docs/ora_config/description.html) now support two types to manage auditing inside of an oracle database. If for example you wanted to enable statement auditing for `PUBLIC DATABASE LINK` statements, you could do this like this:

```puppet
ora_statement_audit { 'PUBLIC DATABASE LINK@MY_DB':
  ensure => 'present',
}
```

Disabling would be as easy as setting `ensure` to `absent`:

```puppet
ora_statement_audit { 'PUBLIC DATABASE LINK@MY_DB':
  ensure => 'absent',
}
```

Check the [documentation](/docs/ora_config/ora_statement_audit.html) for all posibilities of [`ora_statement_audit`](/docs/ora_config/ora_statement_audit.html).


The other type of auditing that is now supported is object auditing.

```puppet
ora_object_audit { 'SYS.AUD$@test':
  ensure            => 'present',
  comment_failure   => 'by_access',
  comment_success   => 'by_access',
  grant_failure     => 'my_session',
  grant_success     => 'by_session',
}
```
Check the [documentation](/docs/ora_config/ora_object_audit.html) for all posibilities of [`ora_object_audit_audit`](/docs/ora_config/ora_object_audit.html).

## ora_service now support clusters

The [ora_service]((/docs/ora_config/ora_service.html)) now support a extensive range of properties to manage services on a Oracle RAC cluster. Here is an example:

```puppet
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
  preferred_instances => ['DB1', 'DB2'],
  server_pool         => ['POOL.DEVELOPMENT.ORG'],
  service_role        => 'PRIMARY',
  status              => 'running',
  taf_policy          => 'NONE',
}
```

## Using different OS users

In older versions of [`ora_config`](/shop/products/puppet-ora_config-module) using different os users for Oracle and ASM was support but albeit very difficult. In [`ora_config`](/docs/ora_config/description.html) version 2.3. it has become very easy. You can now use the [`ora_setting`](/docs/ora_config/ora_setting.html) type to manage all properties for connecting puppet to a database. Here is an example:

```puppet
ora_setting { 'DB02':
  oracle_home => '/u01/app/oracle/product/12.1.0/db_home1',
  os_user     => 'non-standard',
}
```

With the introduction of [`ora_config`](/shop/products/puppet-ora_config-module) 2.3 **ALL** database need a [`ora_setting`](/docs/ora_config/ora_setting.html) in the manifest. When you are using `ora_database` to create the database, this is automatically taken care of. When you use `ora_install`  classes to create your database, you must add this to your manifest.

You mast also add [`ora_setting`](/docs/ora_config/ora_setting.html) for you ASM instances. Here is an example:

```puppet
ora_setting { '+ASM':
  oracle_home => '/app/grid/product/12.1/grid',
  os_user     => 'grid',
  syspriv     => 'sysasm',
}
```

## Manage Oracle directory mapping

Using the [`ora_directory`]((/docs/ora_config/ora_directory.html)) type, you can now manage Oracle directory mapping with puppet. Here is an example:

```puppet
ora_directory { 'ORACLE_OCM_CONFIG_DIR2@db':
  ensure         => 'present',
  directory_path => '/opt/oracle/app/11.04/ccr/state',
}
```
## Manage database archivelogging

The startup, archive mode and force logging of the database can now be managed. Not only at creation time, by the properties `autostart`, `archivelog` and `force_logging`:

```puppet
ora_database { 'DB':
  ensure        => 'present',
  archivelog    => 'disabled',
  autostart     => 'false',
  force_logging => 'disabled',
}
```

## Add support for `puppet generate type`

The Puppet server (both Open Source as well as Puppet Enterprise) always had problems when using multiple version of a ruby type in multiple environments. Puppet now added `puppet generate type` as one of the methods to combat this problem. [`ora_config`](/shop/products/puppet-ora_config-module) version 2.3 fully supports the `puppet generate type` command.

## Multiple smaller changes

- The tablespaces mentioned in quotas are now auto required.
- Better informational logging. All output now contains the full path of the resources. This allows you to find the specific resource much easier in a large manifest.
- Allow additional `grants` or `revokes` to be specified. Check [here] for full documentation.
- Support K/M etc on `private_sga property` of `ora_profile`.
- Fix autorequires on resources with a specified sid.
- Fixed problems in `logfile_groups` from [`ora_database`]
