# ex: si ts=4 sw=4 et

define shorewall::simple::iface {
    if $::shorewall::simple::ipv4 {
        shorewall::iface { "iface-${name}-ipv4":
            interface => $name,
            proto     => 'ipv4',
            options   => [ 'tcpflags', 'nosmurfs', 'routefilter', 'dhcp', 'optional' ],
            zone      => $::shorewall::simple::inet,
        }
    }

    if $::shorewall::simple::ipv6 {
        shorewall::iface { "iface-${name}-ipv6":
            interface => $name,
            proto     => 'ipv6',
            options   => [ 'tcpflags', 'nosmurfs', 'routefilter', 'dhcp', 'optional' ],
            zone      => $::shorewall::simple::inet,
        }
    }
}
