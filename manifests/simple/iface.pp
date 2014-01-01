# ex: si ts=4 sw=4 et

define iface (
    $ipv4    = $shorewall::simple::ipv4,
    $ipv6    = $shorewall::simple::ipv6,
    $dynamic = false,
) {
    shorewall::iface { $name:
        ipv4    => $ipv4,
        ipv6    => $ipv6,
        options => $dynamic ? {
            true  => [ 'tcpflags', 'nosmurfs', 'routefilter', 'dhcp', 'optional' ],
            false => [ 'tcpflags', 'nosmurfs', 'routefilter' ],
        },
        zone    => $shorewall::simple::inet,
    }
}
