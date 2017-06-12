# == Class: ora_install::prepareautostart
#
#  prepare autostart of the database for linux
#
class ora_install::prepareautostart(
  $oracle_home  = undef,
  $user         = 'oracle',
  $service_name = 'dbora'
){
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
        logoutput => true,
      }
    }
    'Ubuntu', 'Debian':{
      exec { "enable service ${service_name}":
        command   => "update-rc.d ${service_name} defaults",
        require   => File["/etc/init.d/${service_name}"],
        user      => 'root',
        unless    => "ls /etc/rc3.d/*${service_name} | /bin/grep \'${service_name}\'",
        path      => $exec_path,
        logoutput => true,
      }
    }
    'Solaris': {
      file { '/tmp/oradb_smf.xml' :
        ensure  => present,
        mode    => '0755',
        owner   => 'root',
        content => template('ora_install/oradb_smf.xml.erb'),
      }
      exec { "enable service ${service_name}":
        command   => 'svccfg -v import /tmp/oradb_smf.xml',
        require   => File['/tmp/oradb_smf.xml',"${dbora_location}/${service_name}"],
        user      => 'root',
        unless    => 'svccfg list | grep oracledatabase',
        path      => $exec_path,
        logoutput => true,
      }
    }
    default: {
      fail('Unrecognized operating system, please use it on a Linux or SunOS host')
    }
  }
}
