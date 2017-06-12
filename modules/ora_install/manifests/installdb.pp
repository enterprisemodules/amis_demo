# == Class: ora_install::installdb
#
# The database_type value should contain only one of these choices.
# EE     : Enterprise Edition
# SE     : Standard Edition
# SEONE  : Standard Edition One
#
#
define ora_install::installdb(
  $version                   = undef,
  $file                      = undef,
  $database_type             = 'SE',
  $ora_inventory_dir         = undef,
  $oracle_base               = undef,
  $oracle_home               = undef,
  $ee_options_selection      = false,
  $ee_optional_components    = undef, # 'oracle.rdbms.partitioning:11.2.0.4.0,oracle.oraolap:11.2.0.4.0,oracle.rdbms.dm:11.2.0.4.0,oracle.rdbms.dv:11.2.0.4.0,oracle.rdbms.lbac:11.2.0.4.0,oracle.rdbms.rat:11.2.0.4.0'
  $create_user               = undef,
  $bash_profile              = true,
  $user                      = 'oracle',
  $user_base_dir             = '/home',
  $group                     = 'dba',
  $group_install             = 'oinstall',
  $group_oper                = 'oper',
  $download_dir              = '/install',
  $temp_dir                  = '/tmp',
  $zip_extract               = true,
  $puppet_download_mnt_point = undef,
  $remote_file               = true,
  $cluster_nodes             = undef,
  $cleanup_install_files     = true,
  $is_rack_one_install       = false,
  $logoutput                 = 'on_failure',
)
{
  if ( $create_user == true ){
    fail("create_user parameter on installdb ${title} is removed from this oradb module, you need to create the oracle user and its groups yourself")
  }

  if ( $create_user == false ){
    notify {"create_user parameter on installdb ${title} can be removed, create_user feature is removed from this oradb module":}
  }

  if (!( $version in ['12.2.0.1','12.1.0.1','12.1.0.2','11.2.0.3','11.2.0.4', '11.2.0.1'])){
    fail('Unrecognized database install version, use 11.2.0.1|11.2.0.3|11.2.0.4|12.1.0.1|12.1.0.2|12.2.0.1')
  }

  if ( !($::kernel in ['Linux','SunOS'])){
    fail('Unrecognized operating system, please use it on a Linux or SunOS host')
  }

  if ( !($database_type in ['EE','SE','SEONE'])){
    fail('Unrecognized database type, please use EE|SE|SEONE')
  }

  if ( $oracle_base == undef or is_string($oracle_base) == false) {fail('You must specify an oracle_base') }
  if ( $oracle_home == undef or is_string($oracle_home) == false) {fail('You must specify an oracle_home') }

  if ( $oracle_base in $oracle_home == false ){
    fail('oracle_home folder should be under the oracle_base folder')
  }

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

  $exec_path     = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

  if $puppet_download_mnt_point == undef {
    $mount_point     = 'puppet:///modules/ora_install/'
  } else {
    $mount_point     = $puppet_download_mnt_point
  }

  if $ora_inventory_dir == undef {
    $ora_inventory = "${oracle_base}/oraInventory"
  } else {
    $ora_inventory = "${ora_inventory_dir}/oraInventory"
  }

  db_directory_structure{"oracle structure ${version}":
    ensure            => present,
    oracle_base_dir   => $oracle_base,
    ora_inventory_dir => $ora_inventory,
    download_dir      => $download_dir,
    os_user           => $user,
    os_group          => $group_install,
  }

  if ( $continue ) {

    if ( $zip_extract ) {
      # In $download_dir, will Puppet extract the ZIP files or is this a pre-extracted directory structure.

      if ( $version in ['11.2.0.1','12.1.0.1','12.1.0.2']) {
        $file1 =  "${file}_1of2.zip"
        $file2 =  "${file}_2of2.zip"
      }

      if ( $version in ['11.2.0.3','11.2.0.4']) {
        $file1 =  "${file}_1of7.zip"
        $file2 =  "${file}_2of7.zip"
      }

      if ( $version in ['12.2.0.1']) {
        $file1 =  "${file}.zip"
      }

      if $remote_file == true {

        file { "${download_dir}/${file1}":
          ensure  => present,
          source  => "${mount_point}/${file1}",
          mode    => '0775',
          owner   => $user,
          group   => $group,
          require => Db_directory_structure["oracle structure ${version}"],
          before  => Exec["extract ${download_dir}/${file1}"],
        }

        # db file 2 installer zip
        if $file2 != undef {
          file { "${download_dir}/${file2}":
            ensure  => present,
            source  => "${mount_point}/${file2}",
            mode    => '0775',
            owner   => $user,
            group   => $group,
            require => File["${download_dir}/${file1}"],
            before  => Exec["extract ${download_dir}/${file2}"]
          }
        }
        $source = $download_dir
      } else {
        $source = $mount_point
      }

      exec { "extract ${download_dir}/${file1}":
        command   => "unzip -o ${source}/${file1} -d ${download_dir}/${file}",
        timeout   => 0,
        logoutput => $logoutput,
        path      => $exec_path,
        user      => $user,
        group     => $group,
        require   => Db_directory_structure["oracle structure ${version}"],
        before    => Exec["install oracle database ${title}"],
      }
      if $file2 != undef {
        exec { "extract ${download_dir}/${file2}":
          command   => "unzip -o ${source}/${file2} -d ${download_dir}/${file}",
          timeout   => 0,
          logoutput => $logoutput,
          path      => $exec_path,
          user      => $user,
          group     => $group,
          require   => Exec["extract ${download_dir}/${file1}"],
          before    => Exec["install oracle database ${title}"],
        }
      }
    }

    ora_install::utils::dborainst{"database orainst ${version}":
      ora_inventory_dir => $ora_inventory,
      os_group          => $group_install,
    }

    if ! defined(File["${download_dir}/db_install_${version}.rsp"]) {
      file { "${download_dir}/db_install_${version}.rsp":
        ensure  => present,
        content => template("ora_install/db_install_${version}.rsp.erb"),
        mode    => '0775',
        owner   => $user,
        group   => $group,
        require => [Ora_install::Utils::Dborainst["database orainst ${version}"],
                    Db_directory_structure["oracle structure ${version}"],],
      }
    }

    exec { "install oracle database ${title}":
      command     => "/bin/sh -c 'unset DISPLAY;${download_dir}/${file}/database/runInstaller -silent -waitforcompletion -ignoreSysPrereqs -ignorePrereq -responseFile ${download_dir}/db_install_${version}.rsp'",
      creates     => "${oracle_home}/dbs",
      environment => ["USER=${user}","LOGNAME=${user}","TMP=${temp_dir}"],
      timeout     => 0,
      returns     => [6,0],
      path        => $exec_path,
      user        => $user,
      group       => $group_install,
      cwd         => $oracle_base,
      logoutput   => $logoutput,
      require     => [Ora_install::Utils::Dborainst["database orainst ${version}"],
                      File["${download_dir}/db_install_${version}.rsp"]],
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

    exec { "run root.sh script ${title}":
      command   => "${oracle_home}/root.sh",
      user      => 'root',
      group     => 'root',
      path      => $exec_path,
      cwd       => $oracle_base,
      logoutput => $logoutput,
      require   => Exec["install oracle database ${title}"],
    }

    file { $oracle_home:
      ensure  => directory,
      recurse => false,
      replace => false,
      mode    => '0775',
      owner   => $user,
      group   => $group_install,
      require => Exec["install oracle database ${title}","run root.sh script ${title}"],
    }

    # cleanup
    if ( $cleanup_install_files ) {
      if ( $zip_extract ) {
        exec { "remove oracle db extract folder ${title}":
          command => "rm -rf ${download_dir}/${file}",
          user    => 'root',
          group   => 'root',
          path    => $exec_path,
          cwd     => $oracle_base,
          require => [Exec["install oracle database ${title}"],
                      Exec["run root.sh script ${title}"],],
          }

        if ( $remote_file == true ){
          exec { "remove oracle db file1 ${file1} ${title}":
            command => "rm -rf ${download_dir}/${file1}",
            user    => 'root',
            group   => 'root',
            path    => $exec_path,
            cwd     => $oracle_base,
            require => [Exec["install oracle database ${title}"],
                          Exec["run root.sh script ${title}"],],
          }
          exec { "remove oracle db file2 ${file2} ${title}":
            command => "rm -rf ${download_dir}/${file2}",
            user    => 'root',
            group   => 'root',
            path    => $exec_path,
            cwd     => $oracle_base,
            require => [Exec["install oracle database ${title}"],
                        Exec["run root.sh script ${title}"],],
          }
        }
      }
    }
  }
}
