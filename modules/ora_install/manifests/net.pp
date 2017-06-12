# == Class: ora_install::net
#
define ora_install::net(
  $oracle_home  = undef,
  $version      = '11.2',
  $user         = 'oracle',
  $group        = 'dba',
  $db_port      = '1521',
  $download_dir = '/install',
  $temp_dir     = '/tmp',
  $logoutput    = 'on_failure',
){
  if $version in ['11.2','12.1', '12.2'] {
  } else {
    fail('Unrecognized version')
  }

  $exec_path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  file { "${download_dir}/netca_${version}.rsp":
    ensure  => present,
    content => template("ora_install/netca_${version}.rsp.erb"),
    mode    => '0775',
    owner   => $user,
    group   => $group,
  }

  if $version in ['11.2','12.1'] {
    $command = "${oracle_home}/bin/netca /silent /responsefile ${download_dir}/netca_${version}.rsp"
  } else {
    $command = "${oracle_home}/bin/netca -silent -responsefile ${download_dir}/netca_${version}.rsp"
  }

  exec { "install oracle net ${title}":
    command     => $command,
    cwd         => $temp_dir,
    require     => File["${download_dir}/netca_${version}.rsp"],
    creates     => "${oracle_home}/network/admin/listener.ora",
    path        => $exec_path,
    user        => $user,
    group       => $group,
    environment => ["USER=${user}",],
    logoutput   => $logoutput,
  }
}
