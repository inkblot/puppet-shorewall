# ex:ts=4 sw=4 tw=72

define shorewall::multi::zone (
	$ipv4  = $shorewall::multi::ipv4,
	$ipv6  = $shorewall::multi::ipv6,
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
