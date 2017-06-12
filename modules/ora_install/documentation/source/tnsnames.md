Manages an entry in a `tnsnames.ora` file.

Here is an examples on how to use this:

```puppet
oradb::tnsnames{'entry':
  oracle_home          => '/oracle/product/11.2/db',
  user                 => 'oracle',
  group                => 'dba',
  server               => { myserver => { host => soadb.example.nl, port => '1525', protocol => 'TCP' }, { host => soadb2.example.nl, port => '1526', protocol => 'TCP' }},
  connect_service_name => 'soarepos.example.nl',
  connect_server       => 'DEDICATED',
}
```

<%- include_attributes [
  :connect_server,
  :connect_service_name,
  :entry_type,
  :failover,
  :group,
  :loadbalance,
  :oracle_home,
  :server,
  :user
]%>
