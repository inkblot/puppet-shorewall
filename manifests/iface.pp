# ex: si ts=4 sw=4 et

define shorewall::iface (
    $proto         = 'ipv4',
    $interface     = '',
    $options       = [],
    $zone,
    $type          = 'External',
    $in_bandwidth  = '-',
    $out_bandwidth = false,
) {
    $interface_name = $interface ? {
        '' => $name,
        default => $interface,
    }

    case $proto {
        'ipv4': {
            concat::fragment { "shorewall-iface-ipv4-${name}":
                order   => '50',
                target  => '/etc/shorewall/interfaces',
                content => template('shorewall/iface.erb'),
            }

            if $::shorewall::traffic_control and $out_bandwidth {
                concat::fragment { "shorewall-tciface-ipv4-${name}":
                    order   => '50',
                    target  => '/etc/shorewall/tcinterfaces',
                    content => "${name} ${type} ${in_bandwidth} ${out_bandwidth}\n",
                }
            }
        }
        'ipv6': {
            concat::fragment { "shorewall-iface-ipv6-${name}":
                order   => '50',
                target  => '/etc/shorewall6/interfaces',
                content => template('shorewall/iface.erb'),
            }
        }
    }
}
