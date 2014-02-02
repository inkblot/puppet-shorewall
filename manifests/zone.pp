# ex: si ts=4 sw=4 et

define shorewall::zone (
    $zone         = '',
    $parent_zones = [],
    $type         = 'ipv4',
    $options      = '-',
    $in_options   = '-',
    $out_options  = '-',
    $order        = '50',
) {
    $zone_name = $zone ? {
        '' => $name,
        default => $zone,
    }

    if $type != 'ipv6' and $::shorewall::ipv4 {
        concat::fragment { "zone-ipv4-${name}":
            order   => $order,
            target  => '/etc/shorewall/zones',
            content => template('shorewall/zone.erb'),
        }
    }
    if $type != 'ipv6' and $::shorewall::ipv6 {
        concat::fragment { "zone-ipv6-${name}":
            order   => $order,
            target  => '/etc/shorewall6/zones',
            content => template('shorewall/zone.erb'),
        }
    }
}
