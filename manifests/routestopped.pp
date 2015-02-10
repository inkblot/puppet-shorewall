# ex: si ts=4 sw=4 et

define shorewall::routestopped (
    $hosts        = [],
    $options      = [],
    $proto        = '',
    $dest_ports   = [],
    $source_ports = [],
    $ipv4         = $::shorewall::ipv4,
    $ipv6         = $::shorewall::ipv6,
    $order        = '50',
) {
    if $ipv4 {
        concat::fragment { "routestopped-ipv4-${name}":
            order   => $order,
            target  => '/etc/shorewall/routestopped',
            content => template('shorewall/routestopped.erb'),
        }
    }

    if $ipv6 {
        concat::fragment { "routestopped-ipv6-${name}":
            order   => $order,
            target  => '/etc/shorewall6/routestopped',
            content => template('shorewall/routestopped.erb'),
        }
    }
}
