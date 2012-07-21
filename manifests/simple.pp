# ex:ts=4 sw=4 tw=72

class shorewall::simple (
	$ipv4 = $shorewall::params::ipv4,
	$ipv6 = $shorewall::params::ipv6,
) inherits shorewall::params {

	class { 'shorewall::base':
		ipv4 => $ipv4,
		ipv6 => $ipv6,
	}

	define iface (
		$ipv4    = $shorewall::simple::ipv4,
		$ipv6    = $shorewall::simple::ipv6,
		$dynamic = false,
	) {
		if $ipv4 {
			concat::fragment { "shorewall-iface-ipv4-${name}":
				order   => '50',
				target  => '/etc/shorewall/interfaces',
				content => inline_template("inet <%= name %> detect tcpflags,nosmurfs,routefilter<%= dynamic ? ',dhcp,optional' : '' %>\n"),
			}
		}

		if $ipv6 {
			concat::fragment { "shorewall-iface-ipv6-${name}":
				order   => '50',
				target  => '/etc/shorewall6/interfaces',
				content => inline_template("inet <%= name %> detect tcpflags,nosmurfs<%= dynamic ? ',dhcp,optional' : ''%>\n"),
			}
		}
	}

	define port (
		$proto,
		$port,
	) {
		if $shorewall::simple::ipv4 {
			concat::fragment { "open_port-ipv4-${proto}-${port}":
				order   => '50',
				target  => '/etc/shorewall/rules',
				content => inline_template("ACCEPT inet \$FW ${proto} ${port}\n"),
			}
		}

		if $shorewall::simple::ipv6 {
			concat::fragment { "open_port-ipv6-${proto}-${port}":
				order   => '50',
				target  => '/etc/shorewall6/rules',
				content => inline_template("ACCEPT inet \$FW ${proto} ${port}\n"),
			}
		}
	}

	if $ipv4 {
		# ip4 zones (just inet)
		file { '/etc/shorewall/zones':
			mode    => 0644,
			content => "local firewall\ninet ipv4\n",
			notify  => Exec['shorewall-reload'],
		}

		# ip4 interfaces (composed)
		concat { '/etc/shorewall/interfaces':
			mode    => 0644,
			notify  => Exec['shorewall-reload'],
		}

		# ip4 policy (default DROP)
		file { '/etc/shorewall/policy':
			mode    => 0644,
			content => "\$FW all ACCEPT\ninet all DROP info\nall all REJECT info\n",
			notify  => Exec['shorewall-reload'],
		}
	
		# ip4 rules (composed)
		concat { '/etc/shorewall/rules':
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
