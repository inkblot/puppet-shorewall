# ex: si ts=4 sw=4 et

define shorewall::blacklist (
    $address       = '',
    $proto         = '',
    $port          = '',
    $order         = '50',
) {
    validate_re($proto, '^([0-9]+|tcp|udp|-)$')
        if ($port != '') {
        validate_re($port, '^([0-9]+|-)$')
    }

    if $::shorewall::ipv4 {
        concat::fragment { "blacklist-ipv4-${name}":
            order   => $order,
            target  => '/etc/shorewall/blacklist',
            content => template('shorewall/blacklist.erb'),
        }
    }

    if $::shorewall::ipv6 {
        concat::fragment { "blacklist-ipv6-${name}":
            order   => $order,
            target  => '/etc/shorewall6/blacklist',
            content => template('shorewall/blacklist.erb'),
        }
    }
}
