resources { 'firewall':
  purge => true
}

Firewall {
  before  => Class['::base::firewall::post'],
  require => Class['::base::firewall::pre'],
}

# Set $rootGroup automatically
$rootGroup  = "root"
$root_group = "root"
$root_user  = "root"

filebucket {
  "main":
    server => "puppet.${domain}",
}

# global defaults
File {
  backup => 'main',
  owner  => $root_user,
  group  => $root_group,
}

Exec {
  path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/sbin:/usr/local/bin',
}

stage { 'first':
  before => Stage['main'],
}
stage { 'last': }
Stage['main'] -> Stage['last']

Service {
  hasstatus => true,
}

# Audit-only purging of non-managed cron jobs
resources { 'cron':
  purge => true,
  noop  => true,
}

import "nodes.pp"
