define shorewall::param (
  $value,
  $proto = 'ipv4',
  ) {

    validate_string($value)

    case $proto {
      'ipv4': {
        concat::fragment { "shorewall-param-ipv4-${name}":
          target  => '/etc/shorewall/params',
          content => template('shorewall/param.erb'),
        }
      }
      'ipv6': {
        concat::fragment { "shorewall-param-ipv6-${name}":
          target  => '/etc/shorewall6/params',
          content => template('shorewall/param.erb'),
        }
      }
    }
  }
