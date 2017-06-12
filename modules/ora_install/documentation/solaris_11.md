---
layout: documentation
title: Solaris 11 kernel, ulimits and required packages
keywords: open source
sidebar: ora_install_sidebar
toc: false
---

```puppet
package { ['shell/ksh', 'developer/assembler']:
  ensure => present,
}

$install  = "pkg:/group/prerequisite/oracle/oracle-rdbms-server-12-1-preinstall"

package { $install:
  ensure  => present,
}

$groups = ['oinstall','dba' ,'oper' ]

group { $groups :
  ensure      => present,
}

user { 'oracle' :
  ensure      => present,
  uid         => 500,
  gid         => 'dba',
  groups      => $groups,
  shell       => '/bin/bash',
  password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
  home        => "/export/home/oracle",
  comment     => "This user oracle was created by Puppet",
  require     => Group[$groups],
  managehome  => true,
}

$execPath     = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

exec { "projadd group.dba":
  command => "projadd -U oracle -G dba -p 104 group.dba",
  require => User["oracle"],
  unless  => "projects -l | grep -c group.dba",
  path    => $execPath,
}

exec { "usermod oracle":
  command => "usermod -K project=group.dba oracle",
  require => [User["oracle"],Exec["projadd group.dba"],],
  path    => $execPath,
}

exec { "projmod max-shm-memory":
  command => "projmod -sK 'project.max-shm-memory=(privileged,4G,deny)' group.dba",
  require => [User["oracle"],Exec["projadd group.dba"],],
  path    => $execPath,
}

exec { "projmod max-sem-ids":
  command     => "projmod -sK 'project.max-sem-ids=(privileged,100,deny)' group.dba",
  require     => Exec["projadd group.dba"],
  path        => $execPath,
}

exec { "projmod max-shm-ids":
  command     => "projmod -s -K 'project.max-shm-ids=(privileged,100,deny)' group.dba",
  require     => Exec["projadd group.dba"],
  path        => $execPath,
}

exec { "projmod max-sem-nsems":
  command     => "projmod -sK 'process.max-sem-nsems=(privileged,256,deny)' group.dba",
  require     => Exec["projadd group.dba"],
  path        => $execPath,
}

exec { "projmod max-file-descriptor":
  command     => "projmod -sK 'process.max-file-descriptor=(basic,65536,deny)' group.dba",
  require     => Exec["projadd group.dba"],
  path        => $execPath,
}

exec { "projmod max-stack-size":
  command     => "projmod -sK 'process.max-stack-size=(privileged,32MB,deny)' group.dba",
  require     => Exec["projadd group.dba"],
  path        => $execPath,
}

exec { "ipadm smallest_anon_port tcp":
  command     => "ipadm set-prop -p smallest_anon_port=9000 tcp",
  path        => $execPath,
}
exec { "ipadm smallest_anon_port udp":
  command     => "ipadm set-prop -p smallest_anon_port=9000 udp",
  path        => $execPath,
}
exec { "ipadm largest_anon_port tcp":
  command     => "ipadm set-prop -p largest_anon_port=65500 tcp",
  path        => $execPath,
}
exec { "ipadm largest_anon_port udp":
  command     => "ipadm set-prop -p largest_anon_port=65500 udp",
  path        => $execPath,
}

exec { "ulimit -S":
  command => "ulimit -S -n 4096",
  path    => $execPath,
}

exec { "ulimit -H":
  command => "ulimit -H -n 65536",
  path    => $execPath,
}

```
