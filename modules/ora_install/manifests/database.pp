# == Class: ora_install::database
#
#
# action        =  createDatabase|deleteDatabase
# database_type  = MULTIPURPOSE|DATA_WAREHOUSING|OLTP
#
define ora_install::database(
  $oracle_base               = undef,
  $oracle_home               = undef,
  $version                   = '12.2', # 11.2|12.1|12.2
  $user                      = 'oracle',
  $group                     = 'dba',
  $download_dir              = '/install',
  $action                    = 'create',
  $template                  = undef,
  $template_type             = 'non-seed',  # non-seed | seed
  $db_name                   = 'orcl',
  $db_domain                 = undef,
  $db_port                   = '1521',
  $sys_password              = 'Welcome01!',
  $system_password           = 'Welcome01!',
  $data_file_destination     = undef,
  $recovery_area_destination = undef,
  $character_set             = 'AL32UTF8',
  $nationalcharacter_set     = 'UTF8',
  $init_params               = undef,
  $sample_schema             = 'TRUE',
  $memory_percentage         = '40',
  $memory_total              = '800',
  $database_type             = 'MULTIPURPOSE', # MULTIPURPOSE|DATA_WAREHOUSING|OLTP
  $em_configuration          = 'NONE',  # CENTRAL|LOCAL|ALL|NONE
  $storage_type              = 'FS', #FS|CFS|ASM
  $asm_snmp_password         = 'Welcome01!',
  $db_snmp_password          = 'Welcome01!',
  $asm_diskgroup             = 'DATA',
  $recovery_diskgroup        = undef,
  $cluster_nodes             = undef,
  $container_database        = false, # 12.1 feature for pluggable database
  $puppet_download_mnt_point = undef,
)
{
  if (!( $version in ['11.2','12.1','12.2'])) {
    fail('Unrecognized version')
  }

  if $action == 'create' {
    $operation_type = 'createDatabase'
  } elsif $action == 'delete' {
    $operation_type = 'deleteDatabase'
  } else {
    fail('Unrecognized database action')
  }

  if (!( $database_type in ['MULTIPURPOSE','DATA_WAREHOUSING','OLTP'])) {
    fail('Unrecognized database_type')
  }

  if (!( $em_configuration in ['NONE','CENTRAL','LOCAL','ALL'])) {
    fail('Unrecognized em_configuration')
  }

  if (!( $storage_type in ['FS','CFS','ASM'])) {
    fail('Unrecognized storage_type')
  }

  if ( $version == '11.2' and $container_database == true ){
    fail('container or pluggable database is not supported on version 11.2')
  }

  $exec_path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  if $puppet_download_mnt_point == undef {
    $mount_point = 'ora_install/'
  } else {
    $mount_point = $puppet_download_mnt_point
  }

  case $::kernel {
    'Linux': {
      $user_home = "/home/${user}"
    }
    'SunOS': {
      $user_home = "/export/home/${user}"
    }
    default: {
      fail('Unrecognized operating system')
    }
  }

  if (is_hash($init_params) or is_string($init_params)) {
    if is_hash($init_params) {
      $init_params_array = sort(join_keys_to_values($init_params, '='))
      $sanitized_ini_params = join($init_params_array,',')
    } else {
      $sanitized_ini_params = $init_params
    }
  } else {
    fail 'init_params only supports a String or a Hash as value type'
  }

  $sanitized_title = regsubst($title, '[^a-zA-Z0-9.-]', '_', 'G')

  if $db_domain {
    $globaldb_name = "${db_name}.${db_domain}"
  } else {
    $globaldb_name = $db_name
  }

  if ! defined(File["${download_dir}/database_${sanitized_title}.rsp"]) {
    file { "${download_dir}/database_${sanitized_title}.rsp":
      ensure  => present,
      content => template("ora_install/dbca_${version}.rsp.erb"),
      mode    => '0770',
      owner   => $user,
      group   => $group,
      before  => Exec["oracle database ${title}"],
    }
  }

  if ( $template ) {
    $template_extention = $template_type ? {
      'non-seed' => 'dbt',
      'seed'     => 'dbc',
      default    => undef,
    }
    if $template_extention == undef {
      fail "parameter template_type value ${template_type} is invalid. It must be either seed or non-seed"
    }

    $templatename = "${download_dir}/${template}_${sanitized_title}.${template_extention}"
    file { $templatename:
      ensure  => present,
      content => template("${mount_point}/${template}.${template_extention}.erb"),
      mode    => '0775',
      owner   => $user,
      group   => $group,
      before  => Exec["oracle database ${title}"],
    }
  }

  if $action == 'create' {
    if ( $template ) {
      if ( $version == '11.2' or $container_database == false ) {
        $command = "${oracle_home}/bin/dbca -silent -createDatabase -templateName ${templatename} -gdbname ${globaldb_name} -responseFile NO_VALUE -sysPassword ${sys_password} -systemPassword ${system_password} -dbsnmpPassword ${db_snmp_password} -asmsnmpPassword ${asm_snmp_password} -storageType ${storage_type} -emConfiguration ${em_configuration}"
      } else {
        $command = "${oracle_home}/bin/dbca -silent -createDatabase -templateName ${templatename} -gdbname ${globaldb_name} -createAsContainerDatabase ${container_database} -responseFile NO_VALUE -sysPassword ${sys_password} -systemPassword ${system_password} -dbsnmpPassword ${db_snmp_password} -asmsnmpPassword ${asm_snmp_password} -storageType ${storage_type} -emConfiguration ${em_configuration}"
      }
    } else {
      $command = "${oracle_home}/bin/dbca -silent -responseFile ${download_dir}/database_${sanitized_title}.rsp"
    }
    exec { "oracle database ${title}":
      command     => $command,
      creates     => "${oracle_base}/admin/${db_name}",
      timeout     => 0,
      path        => $exec_path,
      user        => $user,
      group       => $group,
      cwd         => $oracle_base,
      environment => ["USER=${user}",],
      logoutput   => true,
    }
  } elsif $action == 'delete' {
    exec { "oracle database ${title}":
      command     => "${oracle_home}/bin/dbca -silent -responseFile ${download_dir}/database_${sanitized_title}.rsp",
      onlyif      => "ls ${oracle_base}/admin/${db_name}",
      timeout     => 0,
      path        => $exec_path,
      user        => $user,
      group       => $group,
      cwd         => $oracle_base,
      environment => ["USER=${user}",],
      logoutput   => true,
    }
  }
}
