# ex:ts=4 sw=4 tw=72

define shorewall::multi::iface (
	$ipv4        = $shorewall::multi::ipv4,
	$ipv6        = $shorewall::multi::ipv6,
	$options     = [],
	$zone,
) {
	if $ipv4 {
		concat::fragment { "shorewall-iface-ipv4-${name}":
			order   => '50',
			target  => '/etc/shorewall/interfaces',
			content => inline_template("<%= zone %> <%= name %> detect <%= options.join(',') %>\n"),
		}
	}

	if $ipv6 {
		concat::fragment { "shorewall-iface-ipv6-${name}":
			order   => '50',
			target  => '/etc/shorewall6/interfaces',
			content => inline_template("<%= zone %> <%= name %> detect <%= options.reject { |el,i| el == 'routefilter' }.join(',') %>\n"),
		}
	}
}
