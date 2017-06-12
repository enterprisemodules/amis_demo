This defined type allows you to create or delete a database.

 Under the hood the calls the `dbca` utility to do the work. When you need more control over the individual settings when creating the database, you must use the [`ora_database` custom type of the `ora_config` module](https://www.enterprisemodules.com/docs/ora_config/ora_database.html)

Here is an example on how to use this defined type to create a database:

```puppet
ora_install::database{ 'testDb_Create':
  action                    => 'create',
  oracle_base               => '/oracle',
  oracle_home               => '/oracle/product/11.2/db',
  version                   => '11.2',
  user                      => 'oracle',
  group                     => 'dba',
  download_dir              => '/install',
  action                    => 'create',
  db_name                   => 'test',
  db_domain                 => 'oracle.com',
  db_port                   => '1521',
  sys_password              => 'Welcome01',
  system_password           => 'Welcome01',
  data_file_destination     => "/oracle/oradata",
  recovery_area_destination => "/oracle/flash_recovery_area",
  character_set             => "AL32UTF8",
  nationalcharacter_set     => "UTF8",
  init_params               => {'open_cursors'        => '1000',
                              'processes'           => '600',
                              'job_queue_processes' => '4' },
  sample_schema             => 'TRUE',
  memory_percentage         => "40",
  memory_total              => "800",
  database_type             => "MULTIPURPOSE",
  em_configuration          => "NONE",
  require                   => Ora_install::Listener['start listener'],
}
```

<%- include_attributes [
  :action,
  :asm_diskgroup,
  :asm_snmp_password,
  :character_set,
  :cluster_nodes,
  :container_database,
  :data_file_destination,
  :database_type,
  :db_domain,
  :db_name,
  :db_port,
  :db_snmp_password,
  :download_dir,
  :em_configuration,
  :group,
  :init_params,
  :memory_percentage,
  :memory_total,
  :nationalcharacter_set,
  :oracle_base,
  :oracle_home,
  :puppet_download_mnt_point,
  :recovery_area_destination,
  :recovery_diskgroup,
  :sample_schema,
  :storage_type,
  :sys_password,
  :system_password,
  :template,
  :user,
  :version
]%>
