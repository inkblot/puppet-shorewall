# ex:ts=4 sw=4 tw=72

class shorewall::multi (
	$ipv4           = $shorewall::params::ipv4,
	$ipv6           = $shorewall::params::ipv6,
	$ipv4_tunnels   = false,
	$ipv6_tunnels   = false,
	$default_policy = 'REJECT',
) inherits shorewall::params {

	class { 'shorewall::base':
		ipv4 => $ipv4,
		ipv6 => $ipv6,
	}

	define iface (
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
		$proto   = 'ipv4',
		$type,
		$zone,
		$gateway = '0.0.0.0/0',
	) {
		case $proto {
			'ipv4': {
				if $shorewall::multi::ipv4_tunnels {
					concat::fragment { "tunnel-ipv4-${type}-${gateway}":
						order   => '50',
						target  => '/etc/shorewall/tunnels',
						content => "${type} ${zone} ${gateway}\n",
					}
				} else {
					fail('An ipv4 tunnel has been defined but \'ipv4_tunnels\' is false')
				}
			}
			'ipv6': {
				if $shorewall::multi::ipv6_tunnels {
					concat::fragment { "tunnel-ipv6-${type}-${gateway}":
						order   => '50',
						target  => '/etc/shorewall6/tunnels',
						content => "${type} ${zone} ${gateway}\n",
					}
				} else {
					fail('An ipv6 tunnel has been defined been \'ipv6_tunnels\' is false')
				}
			}
			default: { fail("Unknown value for 'proto': ${proto}") }
		}
	}

	define zone (
		$ipv4 = $shorewall::multi::ipv4,
		$ipv6 = $shorewall::multi::ipv6,
	) {
		if $ipv4 {
			concat::fragment { "zone-ipv4-${name}":
				order   => '50',
				target  => '/etc/shorewall/zones',
				content => "${name} ipv4\n",
			}
		}

		if $ipv6 {
			concat::fragment { "zone-ipv6-${name}":
				order   => '50',
				target  => '/etc/shorewall6/zones',
				content => "${name} ipv6\n",
			}
		}
	}

	define policy (
		$priority,
		$source,
		$dest,
		$action,
		$log_level = '-'
	) {
		if $shorewall::multi::ipv4 {
			concat::fragment { "policy-ipv4-${action}-${source}-to-${dest}":
				order   => "p-${priority}",
				target  => '/etc/shorewall/policy',
				content => "${source} ${dest} ${action} ${log_level}\n",
			}
		}

		if $shorewall::multi::ipv6 {
			concat::fragment { "policy-ipv6-${action}-${source}-to-${dest}":
				order   => "p-${priority}",
				target  => '/etc/shorewall6/policy',
				content => "${source} ${dest} ${action} ${log_level}\n",
			}
		}
	}

	if $ipv4 {
		# ip4 zones (composed)
		concat { '/etc/shorewall/zones':
			mode   => 0644,
			notify => Exec['shorewall-reload'],
		}

		concat::fragment { 'shorewall-zones-local':
			order   => 0,
			target  => '/etc/shorewall/zones',
			content => "local firewall\n",
		}

		# ip4 interfaces (composed)
		concat { '/etc/shorewall/interfaces':
			mode   => 0644,
			notify => Exec['shorewall-reload'],
		}

		# ip4 policy (composed)
		concat { '/etc/shorewall/policy':
			mode   => 0644,
			notify => Exec['shorewall-reload'],
		}

		concat::fragment { 'policy-ipv4-accept-outbound':
			order   => 'a-00',
			target  => '/etc/shorewall/policy',
			content => "\$FW all ACCEPT\n",
		}

		concat::fragment { 'policy-ipv4-drop-all-all':
			order   => 'z-99',
			target  => '/etc/shorewall/policy',
			content => "all all ${default_policy}\n",
		}
	
		# ip4 rules (composed)
		concat { '/etc/shorewall/rules':
			mode   => 0644,
			notify => Exec['shorewall-reload'],
		}

		concat::fragment { 'rule-ipv4-accept-ping':
			order   => '00',
			target  => '/etc/shorewall/rules',
			content => "Ping/ACCEPT all \$FW\n",
		}

		# ipv4 tunnels (composed)
		if $ipv4_tunnels {
			concat { '/etc/shorewall/tunnels':
				mode   => 0644,
				notify => Exec['shorewall-reload'],
			}
		} else {
			file { '/etc/shorewall/tunnels':
				ensure => absent,
				notify => Exec['shorewall-reload'],
			}
		}

		# ip4 shorewall.conf
		file { '/etc/shorewall/shorewall.conf':
			ensure => present,
			notify => Exec['shorewall-reload'],
		}

		exec { 'shorewall-reload':
			command     => '/etc/init.d/shorewall restart',
			refreshonly => true,
		}
	}

	if $ipv6 {
		# ip6 zones (composed)
		concat { '/etc/shorewall6/zones':
			mode   => 0644,
			notify => Exec['shorewall6-reload'],
		}

		concat::fragment { 'shorewall6-zones-local':
			order   => 0,
			target  => '/etc/shorewall6/zones',
			content => "local firewall\n",
		}

		# ip6 interfaces (composed)
		concat { '/etc/shorewall6/interfaces':
			mode   => 0644,
			notify => Exec['shorewall6-reload'],
		}

		# ip6 policy (default DROP)
		concat { '/etc/shorewall6/policy':
			mode   => 0644,
			notify => Exec['shorewall6-reload'],
		}
	
		concat::fragment { 'policy-ipv6-accept-outbound':
			order   => 'a-00',
			target  => '/etc/shorewall6/policy',
			content => "\$FW all ACCEPT\n",
		}

		concat::fragment { 'policy-ipv6-drop-all-all':
			order   => 'z-99',
			target  => '/etc/shorewall6/policy',
			content => "all all DROP\n",
		}
	
		# ip6 rules (composed)
		concat { '/etc/shorewall6/rules':
			mode   => 0644,
			notify => Exec['shorewall6-reload'],
		}

		concat::fragment { 'rule-ipv6-accept-ping':
			order   => '00',
			target  => '/etc/shorewall6/rules',
			content => "Ping/ACCEPT all \$FW\n",
		}

		# ipv6 tunnels (composed)
		if $ipv6_tunnels {
			concat { '/etc/shorewall6/tunnels':
				mode   => 0644,
				notify => Exec['shorewall6-reload'],
			}
		} else {
			file { '/etc/shorewall6/tunnels':
				ensure => absent,
				notify => Exec['shorewall6-reload'],
			}
		}

		# ip6 shorewall.conf
		file { '/etc/shorewall6/shorewall6.conf':
			ensure => present,
			notify => Exec['shorewall6-reload'],
		}

		exec { 'shorewall6-reload':
			command     => '/etc/init.d/shorewall6 restart',
			refreshonly => true,
		}
	}
}
