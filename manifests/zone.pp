# ex: si ts=4 sw=4 et

define shorewall::zone (
    $ipv4  = $::shorewall::ipv4,
    $ipv6  = $::shorewall::ipv6,
    $order = '50',
) {
    if $ipv4 {
        concat::fragment { "zone-ipv4-${name}":
            order   => $order,
            target  => '/etc/shorewall/zones',
            content => "${name} ipv4\n",
        }
    }

    if $ipv6 {
        concat::fragment { "zone-ipv6-${name}":
            order   => $order,
            target  => '/etc/shorewall6/zones',
            content => "${name} ipv6\n",
        }
    }
}
