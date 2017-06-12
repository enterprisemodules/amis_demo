Selects the type of database you want to install.

At this point in time the following database types are supported and allowed:

- EE     : Enterprise Edition
- SE     : Standard Edition
- SEONE  : Standard Edition One

Here is an example using a local file specification:

```puppet
ora_install::....{...
  ...
  database_type => 'EE',
  ...
}
```

The default value for the parameter is `SE`
