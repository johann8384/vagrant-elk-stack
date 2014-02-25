class base::sysctl {
  ::sysctl {
    'net.ipv6.conf.all.disable_ipv6': value => 1
  }

  ::sysctl {
    'net.ipv6.conf.default.disable_ipv6': value => 1
  }

  ::sysctl {
    'net.core.somaxconn': value => '65536'
  }

  ::sysctl { "vm.swappiness":
    value => "0",
  }

  ::sysctl { "fs.inotify.max_user_watches":
    value => "100000",
  }

  ::sysctl { 'kernel.core_pattern':
    value => '/tmp/core-%e-%s-%u-%g-%p-%t',
  }
}
