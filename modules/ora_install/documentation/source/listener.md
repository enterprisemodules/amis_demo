Manage the oracle listener[DEPRECATED]

This defined type is deprecated. Please use [db_listener](TODO) custom type to manage your listener.

Here is an example on how to use this:

```puppet
ora_install::listener{'start listener':
  action        => 'start',  # running|start|abort|stop
  oracle_base   => '/oracle',
  oracle_home   => '/oracle/product/11.2/db',
  user          => 'oracle',
  group         => 'dba',
  listener_name => 'listener' # which is the default and optional
}
```


<%- include_attributes [
  :action,
  :group,
  :listener_name,
  :oracle_home,
  :user
]%>
