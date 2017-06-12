This defined type create's a startup script for the specified database and enables the service. The end result is that the named Oracle database is
restarted after a system restart.

Here is an example on how to use it:

``` puppet
ora_install::autostartdatabase{ 'autostart oracle':
  oracle_home             => '/oracle/product/12.1/db',
  user                    => 'oracle',
  db_name                 => 'test',
}

```
<%- include_attributes [
  :db_name,
  :oracle_home,
  :service_name,
  :user
]%>
