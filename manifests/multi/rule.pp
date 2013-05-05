# ex:ts=4 sw=4 tw=72

define shorewall::multi::rule (
	$proto,
	$port,
	$source,
	$dest,
	$action,
	$order  = '50',
) {
	if $shorewall::multi::ipv4 {
		concat::fragment { "rule-ipv4-${source}-to-${dest}-${proto}-${port}":
			order   => $order,
			target  => '/etc/shorewall/rules',
			content => "${action} ${source} ${dest} ${proto} ${port}\n",
		}
	}

	if $shorewall::multi::ipv6 {
		concat::fragment { "rule-ipv6-${source}-to-${dest}-${proto}-${port}":
			order   => $order,
			target  => '/etc/shorewall/rules',
			content => "${action} ${source} ${dest} ${proto} ${port}\n",
		}
	}
}
