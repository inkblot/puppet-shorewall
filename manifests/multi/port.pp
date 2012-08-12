# ex:ts=4 sw=4 tw=72

define shorewall::multi::port (
	$proto,
	$port,
	$source,
) {
	if $shorewall::multi::ipv4 {
		concat::fragment { "port-ipv4-${source}-${proto}-${port}":
			order   => '50',
			target  => '/etc/shorewall/rules',
			content => "ACCEPT ${source} \$FW ${proto} ${port}\n",
		}
	}

	if $shorewall::multi::ipv6 {
		concat::fragment { "port-ipv6-${source}-${proto}-${port}":
			order   => '50',
			target  => '/etc/shorewall6/rules',
			content => "ACCEPT ${source} \$FW ${proto} ${port}\n",
		}
	}
}
