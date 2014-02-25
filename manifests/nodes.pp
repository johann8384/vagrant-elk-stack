node default {}

node 'elk-client01.ghostlab.net' {
  class { '::base': }

  package { ['nano', 'git', 'screen', 'vim-enhanced', 'rsync', 'bind-utils']:
    ensure => installed,
  }

  class { '::java': }

  class { 'logstash':
    package_url => 'http://download.elasticsearch.org/logstash/logstash/packages/centos/logstash-1.3.3-1_centos.noarch.rpm',
    require => [Class['java']],
  }

  logstash::configfile { 'input_files':
    content  => template('logstash/etc/logstash/conf.d/input-client.conf.erb'),
    order   => 10,
  }

  logstash::configfile { 'output_es':
    content  => template('logstash/etc/logstash/conf.d/output-client.conf.erb'),
    order   => 30,
  }

  augeas { 'logstash':
    context => '/files/etc/sysconfig/logstash',
    changes => 'set START true',
    require => Class['logstash'],
  }
}

node 'elk-server01.ghostlab.net' {
  class { '::base': }

  package { ['nano', 'git', 'screen', 'vim-enhanced', 'rsync', 'bind-utils']:
    ensure => installed,
  }

  class { '::java': }
  class { 'elasticsearch':
    package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.9.noarch.rpm',
    config      => {
      'network' => {
        'host'  => '192.168.65.10'
      }
    }
  }

  firewall { '80 accept Kibana Traffic':
    proto   => 'tcp',
    port    => '80',
    action  => 'accept',
  }

  firewall { '9200 Accept ElasticSearch Traffic':
    proto   => 'tcp',
    port    => '9200',
    action  => 'accept',
  }

  firewall { '514 TCP Accept Syslog Traffic':
    proto   => 'tcp',
    port    => '514',
    action  => 'accept',
  }

  firewall { '514 UDP Accept Syslog Traffic':
    proto   => 'udp',
    port    => '514',
    action  => 'accept',
  }

  firewall { '6379 Accept Redis Traffic':
    proto   => 'tcp',
    port    => '6379',
    action  => 'accept',
  }

  class { 'epel': }
  class { 'redis':
    conf_port => '6379',
    conf_bind => '0.0.0.0',
    system_sysctl => true,
    require => Class['epel'],
  }

  class { 'logstash':
    package_url => 'http://download.elasticsearch.org/logstash/logstash/packages/centos/logstash-1.3.3-1_centos.noarch.rpm',
    require => [Class['java'], Class['redis']],
  }

  logstash::configfile { 'input_files':
    content  => template('logstash/etc/logstash/conf.d/input.conf.erb'),
    order   => 10,
  }

  logstash::configfile { 'output_es':
    content  => template('logstash/etc/logstash/conf.d/output.conf.erb'),
    order   => 30,
  }

  file { '/opt/blacklight/kibana' :
    ensure => directory,
    mode   => '0775',
    require => [File['/opt/blacklight']],
  }

  vcsrepo { '/opt/blacklight/kibana/www':
    ensure    => present,
    provider  => git,
    source    => 'https://github.com/elasticsearch/kibana.git',
    require   => [File['/opt/blacklight/kibana'], Package['git']],
  }

  class { '::nginx': }
  ::nginx::resource::vhost { 'kibana.ghostlab.net':
    ensure   => present,
    www_root => '/opt/blacklight/kibana/www',
  }

  augeas { 'logstash':
    context => '/files/etc/sysconfig/logstash',
    changes => 'set START true',
    require => Class['logstash'],
  }
}
