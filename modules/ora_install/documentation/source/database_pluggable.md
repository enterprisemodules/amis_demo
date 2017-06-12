Creates or delete a pluggable database.

Under the hood, this defined type calls the `dbca` utility to create or delete a pluggable database in the specified source database.

Here is an example on how to create pluggable database:

```puppet
oradb::database_pluggable{'pdb1':
  ensure                   => 'present',
  version                  => '12.1',
  oracle_home_dir          => '/oracle/product/12.1/db',
  user                     => 'oracle',
  group                    => 'dba',
  source_db                => 'orcl',
  pdb_name                 => 'pdb1',
  pdb_admin_username       => 'pdb_adm',
  pdb_admin_password       => 'Welcome01',
  pdb_datafile_destination => "/oracle/oradata/orcl/pdb1",
  create_user_tablespace   => true,
  log_output               => true,
}
```
Here is an example on how to remove a pluggable database:

oradb::database_pluggable{'pdb1':
  ensure                   => 'absent',
  version                  => '12.1',
  oracle_home_dir          => '/oracle/product/12.1/db',
  user                     => 'oracle',
  group                    => 'dba',
  source_db                => 'orcl',
  pdb_name                 => 'pdb1',
  pdb_datafile_destination => "/oracle/oradata/orcl/pdb1",
  log_output               => true,
}


<%- include_attributes [
  :create_user_tablespace,
  :ensure,
  :group,
  :log_output,
  :oracle_home_dir,
  :pdb_admin_password,
  :pdb_admin_username,
  :pdb_datafile_destination,
  :pdb_name,
  :source_db,
  :user,
  :version
]%>
