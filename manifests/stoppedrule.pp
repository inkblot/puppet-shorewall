# ex: si ts=4 sw=4 et

define shorewall::stoppedrule (
  $action,
  $source,
  $dest,
  $proto         = '',
  $port          = '',
  $sport         = '',
  $ipv4          = $::shorewall::ipv4,
  $ipv6          = $::shorewall::ipv6,
  $order         = '50',
) {

  validate_re($action, ['^ACCEPT$','^NOTRACK$','^DROP$'])

  if $proto != '' {
    validate_re($proto, '^(([0-9]+|tcp|udp|icmp|-)(?:,|$))+')
  }

  if $port != '' {
    validate_re($port, ['^:?[0-9]+:?$', '^-$', '^[0-9]+[:,][0-9]+$'])
  }

  if $sport != '' {
    validate_re($sport, ['^:?[0-9]+:?$', '^-$', '^[0-9]+[:,][0-9]+$'])
  }

  if $ipv4 {
    concat::fragment { "stoppedrule-ipv4-${name}":
      order   => $order,
      target  => '/etc/shorewall/stoppedrules',
      content => template('shorewall/stoppedrule.erb'),
    }
  }

  if $ipv6 {
    concat::fragment { "stoppedrule-ipv6-${name}":
      order   => $order,
      target  => '/etc/shorewall6/stoppedrules',
      content => template('shorewall/stoppedrule.erb'),
    }
  }
}
