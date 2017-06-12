---
layout: documentation
title: using non-standard oracle accounts
keywords:
sidebar: ora_config_sidebar
toc: false
---

All oracle custom types use the default oracle os accounts to access your oracle system. Sometimes customers have a requirement to use different os users and os groups. The ora_config custom types support this by setting these accounts using the [`ora_setting`](docs/ora_config/ora_setting.html) type

We recommend sticking to the standard setup. Only use different accounts when your requirements really mandate it.

## The defaults

The custom types use the following defaults:

```
os_user       = 'oracle'
asm_user      = 'grid'
```

## Using a different Oracle os_user

To use a different OS user to connect to oracle, use the [`ora_setting`](docs/ora_config/ora_setting.html) type to set it. Here is an example on how to do this:

```puppet
ora_setting { 'MYDB':
  ...
  os_user  => 'nonstandard_user',
  ...
}
```

## Using a different Grid os_user

To use a different OS user to connect to ASM, use the [`ora_setting`](docs/ora_config/ora_setting.html) type to set it. Here is an example on how to do this:

```puppet
ora_setting { '+ASM1':
  ...
  os_user  => 'nonstandard_user',
  sysuser  => 'sysasm'
  ...
}
```
