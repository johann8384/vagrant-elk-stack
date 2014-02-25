class base {
  include ::base::firewall
  include ::base::sysctl

  file { '/opt/blacklight':
    ensure  => 'directory',
    mode    => '0755',
  }
}
