# == Define:  ora_install::autostartdatabase
#
#  autostart of the database for linux and SunOS
#
define ora_install::autostartdatabase(
  $oracle_home  = undef,
  $db_name      = undef,
  $user         = 'oracle',
  $service_name = 'dbora',
){

  ora_install::prepareautostart_for { $service_name:
    oracle_home => $oracle_home,
    user        => $user,
  }

  $exec_path    = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

  case $::kernel {
    'Linux': {
      $ora_tab = '/etc/oratab'
      $dbora_location = '/etc/init.d'
      $sed_command = "sed -i -e's/:N/:Y/g' ${ora_tab}"
    }
    'SunOS': {
      $ora_tab = '/var/opt/oracle/oratab'
      $dbora_location = '/etc'
      $sed_command = "sed -e's/:N/:Y/g' ${ora_tab} > /tmp/oratab.tmp && mv /tmp/oratab.tmp ${ora_tab}"
    }
    default: {
      fail('Unrecognized operating system, please use it on a Linux or SunOS host')
    }
  }

  exec { "set dbora ${db_name}:${oracle_home}":
    command   => $sed_command,
    unless    => "/bin/grep '^${db_name}:${oracle_home}:Y' ${ora_tab}",
    require   => File["${dbora_location}/dbora"],
    path      => $exec_path,
    logoutput => true,
  }

}
