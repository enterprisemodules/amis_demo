# == Class: ora_install::client
#
#
define ora_install::client(
  $version                   = undef,
  $file                      = undef,
  $oracle_base               = undef,
  $oracle_home               = undef,
  $db_port                   = '1521',
  $user                      = 'oracle',
  $user_base_dir             = '/home',
  $group                     = 'dba',
  $group_install             = 'oinstall',
  $download_dir              = '/install',
  $temp_dir                  = '/tmp',
  $bash_profile              = true,
  $puppet_download_mnt_point = undef,
  $remote_file               = true,
  $logoutput                 = true,
)
{
  # check if the oracle software already exists
  $found = oracle_exists( $oracle_home )

  if $found == undef {
    $continue = true
  } else {
    if ( $found ) {
      $continue = false
    } else {
      notify {"ora_install::installdb ${oracle_home} does not exists":}
      $continue = true
    }
  }

  $ora_inventory = "${oracle_base}/oraInventory"

  db_directory_structure{"client structure ${version}":
    ensure            => present,
    oracle_base_dir   => $oracle_base,
    ora_inventory_dir => $ora_inventory,
    download_dir      => $download_dir,
    os_user           => $user,
    os_group          => $group_install,
  }

  if ( $continue ) {

    $exec_path     = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

    if $puppet_download_mnt_point == undef {
      $mount_point     = 'puppet:///modules/ora_install/'
    } else {
      $mount_point     = $puppet_download_mnt_point
    }

    # db file installer zip
    if $remote_file == true {
      file { "${download_dir}/${file}":
        ensure  => present,
        source  => "${mount_point}/${file}",
        before  => Exec["extract ${download_dir}/${file}"],
        mode    => '0775',
        owner   => $user,
        group   => $group,
        require => Db_directory_structure["client structure ${version}"],
      }
      $source = $download_dir
    } else {
      $source = $mount_point
    }
    exec { "extract ${download_dir}/${file}":
      command   => "unzip -o ${source}/${file} -d ${download_dir}/client_${version}",
      timeout   => 0,
      path      => $exec_path,
      user      => $user,
      group     => $group,
      logoutput => false,
      require   => Db_directory_structure["client structure ${version}"],
    }

    ora_install::utils::dborainst{"oracle orainst ${version}":
      ora_inventory_dir => $ora_inventory,
      os_group          => $group_install,
    }

    if ! defined(File["${download_dir}/db_client_${version}.rsp"]) {
      file { "${download_dir}/db_client_${version}.rsp":
        ensure  => present,
        content => template("ora_install/db_client_${version}.rsp.erb"),
        mode    => '0775',
        owner   => $user,
        group   => $group,
        require => [Ora_install::Utils::Dborainst["oracle orainst ${version}"],
                    Db_directory_structure["client structure ${version}"],],
      }
    }

    # In $download_dir, will Puppet extract the ZIP files or is this a pre-extracted directory structure.
    exec { "install oracle client ${title}":
      command     => "/bin/sh -c 'unset DISPLAY;${download_dir}/client_${version}/client/runInstaller -silent -waitforcompletion -ignoreSysPrereqs -ignorePrereq -responseFile ${download_dir}/db_client_${version}.rsp'",
      require     => [Ora_install::Utils::Dborainst["oracle orainst ${version}"],
                    File["${download_dir}/db_client_${version}.rsp"],
                    Exec["extract ${download_dir}/${file}"]],
      creates     => $oracle_home,
      environment => ["TMP=${temp_dir}"],
      timeout     => 0,
      returns     => [6,0],
      path        => $exec_path,
      user        => $user,
      group       => $group_install,
      logoutput   => $logoutput,
    }

    exec { "run root.sh script ${title}":
      command   => "${oracle_home}/root.sh",
      user      => 'root',
      group     => 'root',
      require   => Exec["install oracle client ${title}"],
      path      => $exec_path,
      logoutput => $logoutput,
    }

    file { "${download_dir}/netca_client_${version}.rsp":
      ensure  => present,
      content => template("ora_install/netca_client_${version}.rsp.erb"),
      require => Exec["run root.sh script ${title}"],
      mode    => '0775',
      owner   => $user,
      group   => $group,
    }

    exec { "install oracle net ${title}":
      command   => "${oracle_home}/bin/netca /silent /responsefile ${download_dir}/netca_client_${version}.rsp",
      require   => [File["${download_dir}/netca_client_${version}.rsp"],Exec["run root.sh script ${title}"],],
      creates   => "${oracle_home}/network/admin/sqlnet.ora",
      path      => $exec_path,
      user      => $user,
      group     => $group,
      logoutput => $logoutput,
    }

    if ( $bash_profile == true ) {
      if ! defined(File["${user_base_dir}/${user}/.bash_profile"]) {
        file { "${user_base_dir}/${user}/.bash_profile":
          ensure  => present,
          # content => template('ora_install/bash_profile.erb'),
          content => regsubst(template('ora_install/bash_profile.erb'), '\r\n', "\n", 'EMG'),
          mode    => '0775',
          owner   => $user,
          group   => $group,
        }
      }
    }

    # cleanup
    exec { "remove oracle client extract folder ${title}":
      command => "rm -rf ${download_dir}/client_${version}",
      user    => 'root',
      group   => 'root',
      path    => $exec_path,
      require => Exec["install oracle net ${title}"],
    }

    if ( $remote_file == true ){
      exec { "remove oracle client file ${file} ${title}":
        command => "rm -rf ${download_dir}/${file}",
        user    => 'root',
        group   => 'root',
        path    => $exec_path,
        require => Exec["install oracle net ${title}"],
      }
    }

  }
}
