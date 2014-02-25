class base::firewall {
 class { '::firewall': }
 class { ['::base::firewall::pre', '::base::firewall::post']: }
}
