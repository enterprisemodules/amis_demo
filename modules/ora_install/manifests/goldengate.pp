#
#
#
define ora_install::goldengate(
  $version                   = '12.2.1',
  $file                      = undef,
  $database_type             = 'Oracle',  # only for > 12.1.2
  $database_version          = 'ORA11g',  # 'ORA11g'|'ORA12c'  only for > 12.1.2
  $database_home             = undef,     # only for > 12.1.2
  $oracle_base               = undef,     # only for > 12.1.2
  $goldengate_home           = undef,
  $manager_port              = undef,
  $user                      = 'ggate',
  $group                     = 'dba',
  $group_install             = 'oinstall',
  $download_dir              = '/install',
  $temp_dir                  = '/tmp',
  $puppet_download_mnt_point = undef,
  $logoutput                 = 'on_failure',
)
{
  $supported_versions = [
    '11.1.1',
    '11.2.1',
    '12.1.2',
    '12.2.1',
  ]

  unless $version in $supported_versions {
    fail "Version ${version} is not supported."
  }

  $version_elements = split($version,'\.')
  $major_version = $version_elements[0]

  if ( $goldengate_home == undef or is_string($goldengate_home) == false) {
    fail('You must specify a goldengate_home')
  }
  if ( $file == undef or is_string($file) == false) {
    fail('You must specify a file')
  }
  if ( $puppet_download_mnt_point == undef or is_string($puppet_download_mnt_point) == false) {
    fail('You must specify a puppet_download_mnt_point')
  }


  if ( $major_version == '12') {
    # check if the oracle software already exists
    if (!( $database_type in ['Oracle'] )) {
      fail('Unrecognized database_type')
    }
    if (!( $database_version in ['ORA11g','ORA12c'] )) {
      fail('Unrecognized database_version')
    }
    if ( $database_home == undef or is_string($database_home) == false) {fail('You must specify a database_home') }
    if ( $oracle_base == undef or is_string($oracle_base) == false) {fail('You must specify an oracle_base') }
    if ( $manager_port == undef or is_integer($manager_port) == false) {fail('You must specify a manager_port') }


    $found = oracle_exists( $goldengate_home )

    if $found == undef {
      $continue = true
    } else {
      if ( $found ) {
        $continue = false
      } else {
        notify {"ora_install::goldengate ${goldengate_home} does not exists":}
        $continue = true
      }
    }
  } else {
    $continue = false
  }


  if ($major_version == '12' ) {
    $ora_inventory    = "${oracle_base}/oraInventory"

    db_directory_structure{"oracle goldengate structure ${version}":
      ensure            => present,
      oracle_base_dir   => $oracle_base,
      ora_inventory_dir => $ora_inventory,
      download_dir      => $download_dir,
      os_user           => $user,
      os_group          => $group_install,
    }
  }

  # only for 12.1.2
  if ( $continue == true ) {

    $ggate_install_dir = 'fbo_ggs_Linux_x64_shiphome'

    file { "${download_dir}/${file}":
      source  => "${puppet_download_mnt_point}/${file}",
      owner   => $user,
      group   => $group,
      require => Db_directory_structure["oracle goldengate structure ${version}"],
    }

    exec { 'extract gg':
      command   => "unzip -o ${download_dir}/${file} -d ${download_dir}",
      creates   => "${download_dir}/${ggate_install_dir}",
      timeout   => 0,
      path      => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
      user      => $user,
      group     => $group,
      logoutput => $logoutput,
      require   => File["${download_dir}/${file}"],
    }

    file { "${download_dir}/oggcore.rsp":
      content => template("ora_install/oggcore_${major_version}.rsp.erb"),
      owner   => $user,
      group   => $group,
      require => Db_directory_structure["oracle goldengate structure ${version}"],
    }

    ora_install::utils::dborainst{"ggate orainst ${version}":
      ora_inventory_dir => $ora_inventory,
      os_group          => $group_install,
    }

    exec { 'install oracle goldengate':
      command     => "/bin/sh -c 'unset DISPLAY;${download_dir}/${ggate_install_dir}/Disk1/runInstaller -silent -waitforcompletion -responseFile ${download_dir}/oggcore.rsp'",
      require     => [File["${download_dir}/oggcore.rsp"],
                    Ora_install::Utils::Dborainst["ggate orainst ${version}"],
                    Exec['extract gg'],],
      creates     => $goldengate_home,
      environment => ["TMP=${temp_dir}"],
      timeout     => 0,
      path        => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
      logoutput   => $logoutput,
      user        => $user,
      group       => $group_install,
      returns     => [3,0],
    }

  }

}
