---
layout: documentation
title: Solaris 10 kernel, ulimits and required packages
keywords: open source
sidebar: ora_install_sidebar
toc: false
---

```puppet
exec { "create /cdrom/unnamed_cdrom":
  command => "/usr/bin/mkdir -p /cdrom/unnamed_cdrom",
  creates => "/cdrom/unnamed_cdrom",
}

mount { "/cdrom/unnamed_cdrom":
  device   => "/dev/dsk/c0t1d0s2",
  fstype   => "hsfs",
  ensure   => "mounted",
  options  => "ro",
  atboot   => true,
  remounts => false,
  require  => Exec["create /cdrom/unnamed_cdrom"],
}

$install = [
             'SUNWarc','SUNWbtool','SUNWcsl',
             'SUNWdtrc','SUNWeu8os','SUNWhea',
             'SUNWi1cs', 'SUNWi15cs',
             'SUNWlibC','SUNWlibm','SUNWlibms',
             'SUNWsprot','SUNWpool','SUNWpoolr',
             'SUNWtoo','SUNWxwfnt'
            ]

package { $install:
  ensure    => present,
  adminfile => "/vagrant/pkgadd_response",
  source    => "/cdrom/unnamed_cdrom/Solaris_10/Product/",
  require   => [Exec["create /cdrom/unnamed_cdrom"],
                Mount["/cdrom/unnamed_cdrom"]
               ],
}
package { 'SUNWi1of':
  ensure    => present,
  adminfile => "/vagrant/pkgadd_response",
  source    => "/cdrom/unnamed_cdrom/Solaris_10/Product/",
  require   => Package[$install],
}


# pkginfo -i SUNWarc SUNWbtool SUNWhea SUNWlibC SUNWlibm SUNWlibms SUNWsprot SUNWtoo SUNWi1of SUNWi1cs SUNWi15cs SUNWxwfnt SUNWcsl SUNWdtrc
# pkgadd -d /cdrom/unnamed_cdrom/Solaris_10/Product/ -r response -a response SUNWarc SUNWbtool SUNWhea SUNWlibC SUNWlibm SUNWlibms SUNWsprot SUNWtoo SUNWi1of SUNWi1cs SUNWi15cs SUNWxwfnt SUNWcsl SUNWdtrc


$all_groups = ['oinstall','dba' ,'oper']

group { $all_groups :
  ensure      => present,
}

user { 'oracle' :
  ensure      => present,
  uid         => 500,
  gid         => 'oinstall',
  groups      => ['oinstall','dba','oper'],
  shell       => '/bin/bash',
  password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
  home        => "/home/oracle",
  comment     => "This user oracle was created by Puppet",
  require     => Group[$all_groups],
  managehome  => true,
}

$execPath     = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

exec { "projadd max-shm-memory":
  command => "projadd -p 102  -c 'ora_install' -U oracle -G dba  -K 'project.max-shm-memory=(privileged,4G,deny)' ora_install",
  require => [ User["oracle"],
               Package['SUNWi1of'],
               Package[$install],
             ],
  unless  => "projects -l | grep -c ora_install",
  path    => $execPath,
}

exec { "projmod max-sem-ids":
  command     => "projmod -s -K 'project.max-sem-ids=(privileged,100,deny)' ora_install",
  subscribe   => Exec["projadd max-shm-memory"],
  require     => Exec["projadd max-shm-memory"],
  refreshonly => true,
  path        => $execPath,
}

exec { "projmod max-shm-ids":
  command     => "projmod -s -K 'project.max-shm-ids=(privileged,100,deny)' ora_install",
  require     => Exec["projmod max-sem-ids"],
  subscribe   => Exec["projmod max-sem-ids"],
  refreshonly => true,
  path        => $execPath,
}

exec { "projmod max-sem-nsems":
  command     => "projmod -s -K 'process.max-sem-nsems=(privileged,256,deny)' ora_install",
  require     => Exec["projmod max-shm-ids"],
  subscribe   => Exec["projmod max-shm-ids"],
  refreshonly => true,
  path        => $execPath,
}

exec { "projmod max-file-descriptor":
  command     => "projmod -s -K 'process.max-file-descriptor=(basic,65536,deny)' ora_install",
  require     => Exec["projmod max-sem-nsems"],
  subscribe   => Exec["projmod max-sem-nsems"],
  refreshonly => true,
  path        => $execPath,
}

exec { "projmod max-stack-size":
  command     => "projmod -s -K 'process.max-stack-size=(privileged,32MB,deny)' ora_install",
  require     => Exec["projmod max-file-descriptor"],
  subscribe   => Exec["projmod max-file-descriptor"],
  refreshonly => true,
  path        => $execPath,
}

exec { "usermod oracle":
  command     => "usermod -K project=ora_install oracle",
  require     => Exec["projmod max-stack-size"],
  subscribe   => Exec["projmod max-stack-size"],
  refreshonly => true,
  path        => $execPath,
}

exec { "ndd 1":
  command => "ndd -set /dev/tcp tcp_smallest_anon_port 9000",
  require => Exec["usermod oracle"],
  path    => $execPath,
}
exec { "ndd 2":
  command => "ndd -set /dev/tcp tcp_largest_anon_port 65500",
  require => Exec["ndd 1"],
  path    => $execPath,
}

exec { "ndd 3":
  command => "ndd -set /dev/udp udp_smallest_anon_port 9000",
  require => Exec["ndd 2"],
  path    => $execPath,
}

exec { "ndd 4":
  command => "ndd -set /dev/udp udp_largest_anon_port 65500",
  require => Exec["ndd 3"],
  path    => $execPath,
}

exec { "ulimit -S":
  command => "ulimit -S -n 4096",
  require => Exec["ndd 4"],
  path    => $execPath,
}

exec { "ulimit -H":
  command => "ulimit -H -n 65536",
  require => Exec["ulimit -S"],
  path    => $execPath,
}
```

