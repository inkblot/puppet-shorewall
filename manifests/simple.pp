# ex:ts=4 sw=4 tw=72

class shorewall::simple (
	$ipv4    = $shorewall::params::ipv4,
	$ipv6    = $shorewall::params::ipv6,
	$inet    = 'inet',
	$tunnels = false,
) inherits shorewall::params {

	class { 'shorewall::multi':
		ipv4    => $ipv4,
		ipv6    => $ipv6,
		tunnels => $tunnels,
	}

	define iface (
		$ipv4    = $shorewall::simple::ipv4,
		$ipv6    = $shorewall::simple::ipv6,
		$dynamic = false,
	) {
		shorewall::multi::iface { $name:
			ipv4    => $ipv4,
			ipv6    => $ipv6,
			dynamic => $dynamic,
			zone    => $shorewall::simple::inet,
		}
	}

	define port (
		$proto,
		$port,
	) {
		shorewall::multi::port { $name:
			proto  => $proto,
			port   => $port,
			source => $shorewall::simple::inet,
		}
	}

	define tunnel (
		$type,
		$gateway = '0.0.0.0/0',
	) {
		if $tunnels {
			shorewall::multi::tunnel { $name:
				type    => $type,
				gateway => $gateway,
				zone    => $shorewall::simple::inet,
			}
		}
	}

	if $ipv4 {
		shorewall::multi::zone { $inet:
			proto => 'ipv4',
		}
	}

	if $ipv6 {
		shorewall::multi::zone { $inet:
			proto => 'ipv6',
		}
	}
}
