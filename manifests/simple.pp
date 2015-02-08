# ex: si ts=4 sw=4 et

class shorewall::simple (
    $ipv4           = true,
    $ipv6           = false,
    $inet           = 'inet',
    $ipv4_tunnels   = false,
    $ipv6_tunnels   = false,
    $default_policy = 'REJECT',
    $open_tcp_ports = [ '22' ],
    $open_udp_ports = [],
) {
    $non_lo_ifaces = delete(split($::interfaces, ','), 'lo')

    class { 'shorewall':
        ipv4         => $ipv4,
        ipv6         => $ipv6,
        ipv4_tunnels => $ipv4_tunnels,
        ipv6_tunnels => $ipv6_tunnels,
    }

    shorewall::zone { $inet: }

    shorewall::simple::iface { $non_lo_ifaces: }

    shorewall::policy { "policy-accept-local-to-all":
        priority => '00',
        source   => '$FW',
        dest     => 'all',
        action   => 'ACCEPT',
    }

    shorewall::policy { "policy-drop-$inet-to-local":
        priority => '00',
        source   => $inet,
        dest     => '$FW',
        action   => 'DROP',
    }

    shorewall::policy { "policy-${default_policy}":
        priority => '99',
        source   => 'all',
        dest     => 'all',
        action   => $default_policy,
    }

    shorewall::port { 'port-ping-accept':
        application => 'Ping',
        action      => 'ACCEPT',
        source      => $inet,
    }

    unless empty($open_tcp_ports) {
        shorewall::simple::port { $open_tcp_ports:
            proto  => 'tcp',
        }
    }

    unless empty($open_udp_ports) {
        shorewall::simple::port { $open_udp_ports:
            proto  => 'udp',
        }
    }
}
