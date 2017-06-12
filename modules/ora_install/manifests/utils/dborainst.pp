# == define: ora_install::utils::dborainst
#
#  creates oraInst.loc for oracle products
#
#
##
define ora_install::utils::dborainst
(
  $ora_inventory_dir = undef,
  $os_group          = undef,
){
  case $::kernel {
    'Linux': {
      $ora_inst_path = '/etc'
    }
    'SunOS': {
      $ora_inst_path = '/var/opt/oracle'
      # just to be sure , create the base dir
      if !defined(File[$ora_inst_path]) {
        file { $ora_inst_path:
          ensure => directory,
          before => File["${ora_inst_path}/oraInst.loc"],
          mode   => '0755',
        }
      }
    }
    default: {
        fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }
  }

  if !defined(File["${ora_inst_path}/oraInst.loc"]) {
    file { "${ora_inst_path}/oraInst.loc":
      ensure  => present,
      content => template('ora_install/oraInst.loc.erb'),
      mode    => '0755',
    }
  }
}
