The init parameters to use for the database.

You can use either a comma separated string for init_params or a Hash.

### Using comma separated string

Here is an example using a comma separated string:

``` puppet
ora_install::database{'my_database'
  ...
  init_params => "open_cursors=1000,processes=600,job_queue_processes=4",
  ...
}
```

### Using a Hash

Here is an example using a Hash:

``` puppet
ora_install::database{'my_database'
  ...
  init_params  => {'open_cursors'        => '1000',
                  'processes'           => '600',
                  'job_queue_processes' => '4' },
  }
  ...
}
```
