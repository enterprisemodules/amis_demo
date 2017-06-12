# == Define: ora_install::opatchupgrade
#
# upgrades oracle opatch
#
#
define ora_install::opatchupgrade(
  $oracle_home                = undef,
  $patch_file                 = undef,
  $csi_number                 = undef,
  $support_id                 = undef,
  $opversion                  = undef,
  $user                       = 'oracle',
  $group                      = 'dba',
  $download_dir               = '/install',
  $puppet_download_mnt_point  = undef,
  $logoutput                  = 'on_failure',
){
  $exec_path      = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'
  $patch_dir      = "${oracle_home}/OPatch"

  # if a mount was not specified then get the install media from the puppet master
  if $puppet_download_mnt_point == undef {
    $mount_dir = 'puppet:///modules/ora_install'
  } else {
    $mount_dir = $puppet_download_mnt_point
  }

  # check the opatch version
  $installed_version  = opatch_version($oracle_home)
  $version_parts =  split($opversion,'\.')
  $major_opatch_version = $version_parts[0]
  #
  # major_opatch_version must be either `11` or `12` at this point in time
  #
  case $major_opatch_version {
    '11','12' : { # Do nothing, this is valid
    }
    default: {
      fail "Major opatch version number ${major_opatch_version} not regognised."
    }
  }

  if $installed_version == $opversion {
    $continue = false
  } else {
    notify {"ora_install::opatchupgrade ${title} ${installed_version} installed - performing upgrade":}
    $continue = true
  }

  if ( $continue ) {

    if ! defined(File["${download_dir}/${patch_file}"]) {
      file {"${download_dir}/${patch_file}":
        ensure => present,
        path   => "${download_dir}/${patch_file}",
        source => "${mount_dir}/${patch_file}",
        mode   => '0775',
        owner  => $user,
        group  => $group,
      }
    }

    case $::kernel {
      'Linux', 'SunOS': {
        file { $patch_dir:
          ensure  => absent,
          recurse => true,
          force   => true,
        } ->
        exec { "extract opatch ${title} ${patch_file}":
          command   => "unzip -o ${download_dir}/${patch_file} -d ${oracle_home}",
          path      => $exec_path,
          user      => $user,
          group     => $group,
          logoutput => false,
          require   => File["${download_dir}/${patch_file}"],
        }

        if (
          ($major_opatch_version == '12' and versioncmp($opversion, '12.2.0.1.5') <= 0) or
          ($major_opatch_version == '11' and versioncmp($opversion, '11.2.0.3.14') <= 0)
        ){
          #
          #
          # Older versions need the OCM file. Newer Opatch versions don't support this
          #
          if ( $csi_number != undef and support_id != undef ) {
            exec { "exec emocmrsp ${title} ${opversion}":
              cwd       => $patch_dir,
              command   => "${patch_dir}/ocm/bin/emocmrsp -repeater NONE ${csi_number} ${support_id}",
              path      => $exec_path,
              user      => $user,
              group     => $group,
              logoutput => $logoutput,
              require   => Exec["extract opatch ${patch_file}"],
            }
          } else {

            if ! defined(Package['expect']) {
              package { 'expect':
                ensure  => present,
              }
            }

            file { "${download_dir}/opatch_upgrade_${title}_${opversion}.ksh":
              ensure  => present,
              content => template('ora_install/ocm.rsp.erb'),
              mode    => '0775',
              owner   => $user,
              group   => $group,
            }

            exec { "ksh ${download_dir}/opatch_upgrade_${title}_${opversion}.ksh":
              cwd       => $patch_dir,
              path      => $exec_path,
              user      => $user,
              group     => $group,
              logoutput => $logoutput,
              require   => [File["${download_dir}/opatch_upgrade_${title}_${opversion}.ksh"],
                            Exec["extract opatch ${title} ${patch_file}"],
                            Package['expect'],],
            }
          }
        }

      }
      default: {
        fail('Unrecognized operating system')
      }
    }
  }
}
