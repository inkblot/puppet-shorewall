# ex: si ts=4 sw=4 et

define shorewall::iface (
    $ipv4          = $::shorewall::ipv4,
    $ipv6          = $::shorewall::ipv6,
    $options       = [],
    $zone,
    $type          = 'External',
    $in_bandwidth  = '-',
    $out_bandwidth = false,
) {
    if $ipv4 {
        concat::fragment { "shorewall-iface-ipv4-${name}":
            order   => '50',
            target  => '/etc/shorewall/interfaces',
            content => inline_template("<%= @zone %> <%= @name %> detect <%= @options.join(',') %>\n"),
        }

        if $::shorewall::traffic_control and $out_bandwidth {
            concat::fragment { "shorewall-tciface-ipv4-${name}":
                order   => '50',
                target  => '/etc/shorewall/tcinterfaces',
                content => "${name} ${type} ${in_bandwidth} ${out_bandwidth}\n",
            }
        }
    }

    if $ipv6 {
        concat::fragment { "shorewall-iface-ipv6-${name}":
            order   => '50',
            target  => '/etc/shorewall6/interfaces',
            content => inline_template("<%= @zone %> <%= @name %> detect <%= @options.reject { |el,i| el == 'routefilter' }.join(',') %>\n"),
        }
    }
}
