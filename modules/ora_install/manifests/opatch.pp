# == Define: ora_install::opatch
#
# installs oracle patches for Oracle products
#
#
define ora_install::opatch(
  $ensure                    = 'present',  #present|absent
  $oracle_product_home       = undef,
  $patch_id                  = undef,
  $patch_file                = undef,
  $clusterware               = false, # opatch auto or opatch apply
  $bundle_sub_patch_id       = undef,
  $bundle_sub_folder         = undef,
  $user                      = 'oracle',
  $group                     = 'dba',
  $download_dir              = '/install',
  $ocmrf                     = false,
  $puppet_download_mnt_point = undef,
  $remote_file               = true,
)
{
  $exec_path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

  case $::kernel {
    'Linux': {
      $ora_inst_path = '/etc'
    }
    'SunOS': {
      $ora_inst_path = '/var/opt/oracle'
    }
    default: {
        fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }
  }

  if $puppet_download_mnt_point == undef {
    $moun_point = 'puppet:///modules/ora_install/'
  } else {
    $moun_point =  $puppet_download_mnt_point
  }

  if $ensure == 'present' {
    if $remote_file == true {
      # the patch used by the opatch
      if ! defined(File["${download_dir}/${patch_file}"]) {
        file { "${download_dir}/${patch_file}":
          ensure => present,
          source => "${moun_point}/${patch_file}",
          mode   => '0775',
          owner  => $user,
          group  => $group,
        }
      }
    }
  }

  case $::kernel {
    'Linux', 'SunOS': {
      if $ensure == 'present' {
        if $remote_file == true {
          exec { "extract opatch ${patch_file} ${title}":
            command   => "unzip -n ${download_dir}/${patch_file} -d ${download_dir}",
            require   => File["${download_dir}/${patch_file}"],
            creates   => "${download_dir}/${patch_id}",
            path      => $exec_path,
            user      => $user,
            group     => $group,
            logoutput => false,
            before    => Db_opatch["${patch_id} ${title}"],
          }
        } else {
          exec { "extract opatch ${patch_file} ${title}":
            command   => "unzip -n ${moun_point}/${patch_file} -d ${download_dir}",
            creates   => "${download_dir}/${patch_id}",
            path      => $exec_path,
            user      => $user,
            group     => $group,
            logoutput => false,
            before    => Db_opatch["${patch_id} ${title}"],
          }
        }
      }

      # sometimes the bundle patch inside an other folder
      if ( $bundle_sub_folder ) {
        $extracted_patch_dir = "${download_dir}/${patch_id}/${bundle_sub_folder}"
      } else {
        $extracted_patch_dir = "${download_dir}/${patch_id}"
      }

      if $ocmrf == true {

        db_opatch{ "${patch_id} ${title}":
          ensure                  => $ensure,
          patch_id                => $patch_id,
          os_user                 => $user,
          oracle_product_home_dir => $oracle_product_home,
          orainst_dir             => $ora_inst_path,
          extracted_patch_dir     => $extracted_patch_dir,
          ocmrf_file              => "${oracle_product_home}/OPatch/ocm.rsp",
          bundle_sub_patch_id     => $bundle_sub_patch_id,
          opatch_auto             => $clusterware,
        }

      } else {

        db_opatch{ "${patch_id} ${title}":
          ensure                  => $ensure,
          patch_id                => $patch_id,
          os_user                 => $user,
          oracle_product_home_dir => $oracle_product_home,
          orainst_dir             => $ora_inst_path,
          extracted_patch_dir     => $extracted_patch_dir,
          bundle_sub_patch_id     => $bundle_sub_patch_id,
          opatch_auto             => $clusterware,
        }

      }
    }
    default: {
      fail('Unrecognized operating system')
    }
  }
}
