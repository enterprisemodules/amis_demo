# Docs
# TODO: Write documentation
class profile::oradb::software(
  $version,
  $file_name,
  $type,
)
{
  include profile
  include profile::oradb


  $dirs = [
    '/u02',
    '/u03',
    '/u02/oradata',
    '/u03/fast_recovery_area',
  ]

  file{$dirs:
    ensure => directory,
    owner  => 'oracle',
    group  => 'dba',
    mode   => '0744',
  } ->

  file{'/tmp': ensure => 'directory'} ->

  ora_install::installdb{$file_name:
    version                   => $version,
    file                      => $file_name,
    database_type             => $type,
    oracle_base               => $profile::oradb::base,
    oracle_home               => $profile::oradb::home,
    puppet_download_mnt_point => $profile::source_dir,
    remote_file               => true,
  } ->

  ora_install::net{ 'config net8':
    oracle_home  => $profile::oradb::home,
    version      => '12.2',        # Different version then the oracle version
    download_dir => '/tmp',
  } ->

  ora_install::listener{'start listener':
    oracle_base => $profile::oradb::base,
    oracle_home => $profile::oradb::home,
    action      => 'start',
  } ->

  file {"${profile::oradb::base}/admin":
    ensure => 'directory',
    owner  => 'oracle',
    group  => 'oinstall',
    mode   => '0775',
  }


}
