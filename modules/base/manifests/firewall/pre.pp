class base::firewall::pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto   => 'icmp',
    action  => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    proto   => 'all',
    state   => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }->
  firewall { '22 accept SSH':
    proto   => 'tcp',
    port    => 22,
    action  => 'accept',
  }->
  firewall { '003 allow all LAN':
    proto   => 'all',
    source  => '192.168.65.0/24',
    action  => 'accept',
  }->
  firewall { '004 allow all CTX':
    proto   => 'all',
    source  => '199.119.120.0/24',
    action  => 'accept',
  }
}
