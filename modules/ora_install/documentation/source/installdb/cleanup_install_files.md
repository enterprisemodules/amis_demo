Cleanup extracted files after use.

This is a boolean value. When you set this value to `true`. The installer class will
remove all extracted zip files after it has done its work.

The default value is `true`

Here is an example:

```puppet
ora_install::....{...
  ...
  cleanup_install_files => false,  # Keep all unzipped files
  ...
}
```
