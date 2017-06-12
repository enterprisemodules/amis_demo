Defined type to start and stop a database. [DEPRECATED]

This is defined type to start or stop a database. Usage of this type is discouraged. Please use [db_control](TODO) for this function.

Here is an example on how to use this:
```puppet
oradb::dbactions{ 'stop testDb':
  db_name     => 'test',
  oracle_home => '/oracle/product/11.2/db',
  user        => 'oracle',
  group       => 'dba',
  action      => 'stop',
}
```

<%- include_attributes [
  :action,
  :db_name,
  :db_type,
  :grid_home,
  :group,
  :oracle_home,
  :user
]%>
