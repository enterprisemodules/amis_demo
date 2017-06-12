Installs the Oracle goldengate software.

This module supports the following versions:

- 11.2.1
- 12.1.2

Here is an example on how to use this:

```puppet
ora_install::goldengate{ 'ggate12.1.2':
  version                  => '12.1.2',
  file                     => '121200_fbo_ggs_Linux_x64_shiphome.zip',
  database_type            => 'Oracle',
  database_version         => 'ORA11g',
  database_home            => '/oracle/product/12.1/db',
  oracle_base              => '/oracle',
  goldengate_home          => "/oracle/product/12.1/ggate",
  manager_port             => 16000,
  user                     => 'ggate',
  group                    => 'dba',
  group_install            => 'oinstall',
  download_dir             => '/install',
  puppet_download_mnt_point => puppet://modules/software,
}

```

<%- include_attributes [
  :database_home,
  :database_type,
  :database_version,
  :download_dir,
  :file,
  :goldengate_home,
  :group,
  :group_install,
  :manager_port,
  :oracle_base,
  :puppet_download_mnt_point,
  :tar_file,
  :temp_dir,
  :user,
  :version
]%>
