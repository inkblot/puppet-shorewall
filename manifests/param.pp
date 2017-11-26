define shorewall::param (
  $value,
  $proto = 'ipv4',
) {

  validate_string($value)

  case $proto {
    'ipv4': {
      augeas { "shorewall-param-${name}":
        changes => "set /files/etc/shorewall/params/${name} ${value}",
        lens    => 'Shellvars.lns',
        incl    => '/etc/shorewall/params',
        notify  => Service['shorewall'],
        require => Package['shorewall'],
      }
    }
    'ipv6': {
      augeas { "shorewall6-param-${name}":
        changes => "set /files/etc/shorewall6/params/${name} ${value}",
        lens    => 'Shellvars.lns',
        incl    => '/etc/shorewall6/params',
        notify  => Service['shorewall6'],
        require => Package['shorewall6'],
      }
    }
  }
}
