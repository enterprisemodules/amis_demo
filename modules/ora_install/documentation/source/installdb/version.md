Specifies the version of the component you want to manage or install.

At this point in type we support the installation of:

- 11.2.0.1
- 11.2.0.3
- 11.2.0.4
- 12.1.0.1
- 12.1.0.2

Here is an example on how to specify the version:

```puppet
ora_install::....{...
  ...
  version => '12.1.0.2',
  ...
}
```
