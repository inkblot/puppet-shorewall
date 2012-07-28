# ex:ts=4 sw=4 tw=72

class shorewall::multi (
	$ipv4 = $shorewall::params::ipv4,
	$ipv6 = $shorewall::params::ipv6,
) inherits shorewall::params {

	class { 'shorewall::base':
		ipv4 => $ipv4,
		ipv6 => $ipv6,
	}

	define iface (
		$ipv4    = $shorewall::multi::ipv4,
		$ipv6    = $shorewall::multi::ipv6,
		$dynamic = false,
		$zone,
	) {
		if $ipv4 {
			concat::fragment { "shorewall-iface-ipv4-${name}":
				order   => '50',
				target  => '/etc/shorewall/interfaces',
				content => inline_template("<%= zone %> <%= name %> detect tcpflags,nosmurfs,routefilter<%= dynamic ? ',dhcp,optional' : '' %>\n"),
			}
		}

		if $ipv6 {
			concat::fragment { "shorewall-iface-ipv6-${name}":
				order   => '50',
				target  => '/etc/shorewall6/interfaces',
				content => inline_template("<%= zone %> <%= name %> detect tcpflags,nosmurfs<%= dynamic ? ',dhcp,optional' : ''%>\n"),
			}
		}
	}

	define port (
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

	define tunnel (
		$type,
		$zone,
		$gateway = '0.0.0.0/0',
	) {
		if $shorewall::multi::ipv4 {
			concat::fragment { "tunnel-ipv4-${type}-${gateway}":
				order   => '50',
				target  => '/etc/shorewall/tunnels',
				content => "${type} ${zone} ${gateway}\n",
			}
		}

		if $shorewall::multi::ipv6 {
			concat::fragment { "tunnel-ipv6-${type}-${gateway}":
				order   => '50',
				target  => '/etc/shorewall6/tunnels',
				content => "${type} ${zone} ${gateway}\n",
			}
		}
	}

	define zone (
		$proto   = 'ipv4',
		$type    = '',
	) {
		if $proto == 'ipv4' {
			$real_type = $type ? {
				'' => 'ipv4',
				default => $type,
			}
			concat::fragment { "shorewall-zone-ipv4-${name}":
				order   => '50',
				target  => '/etc/shorewall/zones',
				content => "${name} ${real_type}\n",
			}
		}

		if $proto == 'ipv6' {
			$real_type = $type ? {
				'' => 'ipv6',
				default => $type,
			}
			concat::fragment { "shorewall-zone-ipv6-${name}":
				order   => '50',
				target  => '/etc/shorewall6/zones',
				content => "${name} ${real_type}\n",
			}
		}
	}

	if $ipv4 {
		# ip4 zones (composed)
		concat { '/etc/shorewall/zones':
			mode    => 0644,
			notify  => Exec['shorewall-reload'],
		}

		concat::fragment { 'shorewall-zones-local':
			order   => 0,
			target  => '/etc/shorewall/zones',
			content => "local firewall\n",
		}

		# ip4 interfaces (composed)
		concat { '/etc/shorewall/interfaces':
			mode    => 0644,
			notify  => Exec['shorewall-reload'],
		}

		# ip4 policy (composed)
		concat { '/etc/shorewall/policy':
			mode    => 0644,
			notify  => Exec['shorewall-reload'],
		}

		concat::fragment { 'policy-accept-outbound':
			order   => '00',
			target  => '/etc/shorewall/policy',
			content => "\$FW all ACCEPT\n",
		}

		concat::fragment { 'policy-drop-all-all':
			order   => '99',
			target  => '/etc/shorewall/policy',
			content => "all all DROP\n",
		}
	
		# ip4 rules (composed)
		concat { '/etc/shorewall/rules':
			mode    => 0644,
			notify  => Exec['shorewall-reload'],
		}

		# ipv4 tunnels (composed)
		concat { '/etc/shorewall/tunnels':
			mode    => 0644,
			notify  => Exec['shorewall-reload'],
		}

		# ip4 shorewall.conf
		file { '/etc/shorewall/shorewall.conf':
			ensure  => present,
			notify  => Exec['shorewall-reload'],
		}

		exec { 'shorewall-reload':
			command     => '/etc/init.d/shorewall restart',
			refreshonly => true,
		}
	}

	if $ipv6 {
		# ip6 zones (just inet)
		file { '/etc/shorewall6/zones':
			mode    => 0644,
			content => "local firewall\ninet ipv6\n",
			notify  => Exec['shorewall6-reload'],
		}

		# ip6 interfaces (composed)
		concat { '/etc/shorewall6/interfaces':
			mode    => 0644,
			notify  => Exec['shorewall6-reload'],
		}

		# ip6 policy (default DROP)
		file { '/etc/shorewall6/policy':
			mode    => 0644,
			content => "\$FW all ACCEPT\ninet all DROP info\nall all REJECT info\n",
			notify  => Exec['shorewall6-reload'],
		}
	
		concat::fragment { 'shorewall-ping-rule':
			order   => '00',
			target  => '/etc/shorewall/rules',
			content => "Ping/ACCEPT all \$FW\n",
		}

		# ip6 rules (composed)
		concat { '/etc/shorewall6/rules':
			mode    => 0644,
			notify  => Exec['shorewall6-reload'],
		}

		concat::fragment { 'shorewall6-ping-rule':
			order   => '00',
			target  => '/etc/shorewall6/rules',
			content => "Ping/ACCEPT all \$FW\n",
		}

		# ipv6 tunnels (composed)
		concat { '/etc/shorewall6/tunnels':
			mode    => 0644,
			notify  => Exec['shorewall6-reload'],
		}

		# ip6 shorewall.conf
		file { '/etc/shorewall6/shorewall6.conf':
			ensure  => present,
			notify  => Exec['shorewall6-reload'],
		}

		exec { 'shorewall6-reload':
			command     => '/etc/init.d/shorewall6 restart',
			refreshonly => true,
		}
	}
}
