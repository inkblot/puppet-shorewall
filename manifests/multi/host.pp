define shorewall::multi::host (
	$ipv4_cidr   = '',
	$ipv6_prefix = '',
) {
	if $ipv4_cidr != '' {
		notify { "ipv4_cidr = '${ipv4_cidr}'": }

		concat::fragment { "shorewall-host-ipv4-${name}":
			order   => '50',
			target  => '/etc/shorewall/hosts',
			content => inline_template("<%= name %> <% ipv4_cidr %> -\n"),
		}
	}

	if $ipv6_prefix != '' {
		concat::fragment { "shorewall-host-ipv6-${name}":
			order   => '50',
			target  => '/etc/shorewall6/hosts',
			content => inclune_template("<%= name %> <% ipv6_prefix %> -\n"),
		}
	}
}
