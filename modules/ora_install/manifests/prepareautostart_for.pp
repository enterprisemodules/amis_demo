# == Type: ora_install::prepareautostart_for
#
#  prepare autostart of the database for linux
#
define ora_install::prepareautostart_for(
  $oracle_home  = undef,
  $user         = 'oracle',
  $logoutput    = 'on_failure',
){
  $service_name = $title
  $exec_path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

  case $::kernel {
    'Linux': {
      $dbora_location = '/etc/init.d'
    }
    'SunOS': {
      $dbora_location = '/etc'
    }
    default: {
      fail('Unrecognized kernel, please use it on a Linux or SunOS host')
    }
  }

  file { "${dbora_location}/${service_name}" :
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    content => regsubst(template("ora_install/dbora_${::kernel}.erb"), '\r\n', "\n", 'EMG'),
  }

  case $::operatingsystem {
    'CentOS', 'RedHat', 'OracleLinux', 'SLES': {
      exec { "enable service ${service_name}":
        command   => "chkconfig --add ${service_name}",
        require   => File["/etc/init.d/${service_name}"],
        user      => 'root',
        unless    => "chkconfig --list | /bin/grep \'${service_name}\'",
        path      => $exec_path,
        logoutput => $logoutput,
      }
    }
    'Ubuntu', 'Debian':{
      exec { "enable service ${service_name}":
        command   => "update-rc.d ${service_name} defaults",
        require   => File["/etc/init.d/${service_name}"],
        user      => 'root',
        unless    => "ls /etc/rc3.d/*${service_name} | /bin/grep \'${service_name}\'",
        path      => $exec_path,
        logoutput => $logoutput,
      }
    }
    'Solaris': {
      $file_name = "/tmp/oradb_smf_${service_name}.xml"
      file { $file_name :
        ensure  => present,
        mode    => '0755',
        owner   => 'root',
        content => template('ora_install/oradb_smf.xml.erb'),
      }
      exec { "enable service ${service_name}":
        command   => "svccfg -v import ${file_name}",
        require   => File[$file_name,"${dbora_location}/${service_name}"],
        user      => 'root',
        unless    => 'svccfg list | grep oracledatabase',
        path      => $exec_path,
        logoutput => $logoutput,
      }
    }
    default: {
      fail('Unrecognized operating system, please use it on a Linux or SunOS host')
    }
  }
}
