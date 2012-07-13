# ex:ts=4 sw=4 tw=72

class shorewall::simple inherits shorewall::base {

	define iface (
		$ipv4    = true,
		$ipv6    = false,
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

	define open_port (
		$proto,
		$port,
	) {
		concat::fragment { "open_port-${proto}-${port}":
			order   => '50',
			target  => '/etc/shorewall/rules',
			content => inline_template("ACCEPT inet \$FW ${proto} ${port}\n"),
		}
	}

	file { '/etc/shorewall':
		ensure  => directory,
		require => Package['shorewall'],
	}

	file { '/etc/shorewall6':
		ensure  => directory,
		require => Package['shorewall6'],
	}

	# ip4 zones (just inet)
	file { '/etc/shorewall/zones':
		mode    => 0644,
		content => "local firewall\ninet ipv4\n",
		notify  => Exec['shorewall-reload'],
	}
	# ip6 zones (just inet)
	file { '/etc/shorewall6/zones':
		mode    => 0644,
		content => "local firewall\ninet ipv4\n",
		notify  => Exec['shorewall6-reload'],
	}

	# ip4 interfaces (composed)
	concat { '/etc/shorewall/interfaces':
		mode    => 0644,
		notify  => Exec['shorewall-reload'],
	}

	# ip6 interfaces (composed)
	concat { '/etc/shorewall6/interfaces':
		mode    => 0644,
		notify  => Exec['shorewall6-reload'],
	}

	# ip4 policy (default DROP)
	file { '/etc/shorewall/policy':
		mode    => 0644,
		content => "\$FW all ACCEPT\ninet all DROP info\nall all REJECT info\n",
		notify  => Exec['shorewall-reload'],
	}
	
	# ip6 policy (default DROP)
	file { '/etc/shorewall6/policy':
		mode    => 0644,
		content => "\$FW all ACCEPT\ninet all DROP info\nall all REJECT info\n",
		notify  => Exec['shorewall6-reload'],
	}
	
	# ip4 rules (composed)
	concat { '/etc/shorewall/rules':
		mode    => 0644,
		notify  => Exec['shorewall-reload'],
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

	# ip4 shorewall.conf
	file { '/etc/shorewall/shorewall.conf':
		ensure  => present,
		notify  => Exec['shorewall-reload'],
	}

	# ip6 shorewall.conf
	file { '/etc/shorewall6/shorewall.conf':
		ensure  => present,
		notify  => Exec['shorewall6-reload'],
	}

	exec { 'shorewall-reload':
		command     => '/etc/init.d/shorewall restart',
		refreshonly => true,
	}

	exec { 'shorewall6-reload':
		command     => '/etc/init.d/shorewall6 restart',
		refreshonly => true,
	}

}
