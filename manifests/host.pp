# ex: si ts=4 sw=4 et

define shorewall::host (
    $zone        = '',
    $interface,
    $addresses,
    $exclusion   = '',
    $options     = [ '-' ],
    $proto       = 'ipv4',
) {
    $zone_name = $zone ? {
        '' => $name,
        default => $zone,
    }

    case $proto {
        'ipv4': {
            concat::fragment { "shorewall-host-ipv4-${name}":
                target  => '/etc/shorewall/hosts',
                content => template('shorewall/host.erb'),
            }
        }
        'ipv6': {
            concat::fragment { "shorewall-host-ipv6-${name}":
                target  => '/etc/shorewall6/hosts',
                content => template('shorewall/host.erb'),
            }
        }
    }
}
