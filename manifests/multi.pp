# ex:ts=4 sw=4 tw=72

class shorewall::multi (
	$ipv4            = $shorewall::params::ipv4,
	$ipv6            = $shorewall::params::ipv6,
	$ipv4_tunnels    = false,
	$ipv6_tunnels    = false,
	$default_policy  = 'REJECT',
	$ip_forwarding   = false,
	$traffic_control = false,
) inherits shorewall::params {

	class { 'shorewall::base':
		ipv4 => $ipv4,
		ipv6 => $ipv6,
	}

	if $ipv4 {
		concat { [
				'/etc/shorewall/zones',
				'/etc/shorewall/interfaces',
				'/etc/shorewall/policy',
				'/etc/shorewall/rules',
				'/etc/shorewall/masq',
			]:
			mode   => '0644',
			notify => Exec['shorewall-reload'],
		}

		# ip4 zones
		concat::fragment { 'zones-preamble':
			order   => '00',
			target  => '/etc/shorewall/zones',
			content => "# This file is managed by puppet\n# Edits will be lost\n",
		}

		concat::fragment { 'shorewall-zones-local':
			order   => '01',
			target  => '/etc/shorewall/zones',
			content => "local firewall\n",
		}

		# ip4 interfaces
		concat::fragment { 'interfaces-preamble':
			order   => '00',
			target  => '/etc/shorewall/interfaces',
			content => "# This file is managed by puppet\n# Changes will be lost\n",
		}

		# ip4 policy
		concat::fragment { 'policy-preamble':
			order   => 'a-00',
			target  => '/etc/shorewall/policy',
			content => "# This file is managed by puppet\n# Changes will be lost\n",
		}

		concat::fragment { 'policy-ipv4-accept-outbound':
			order   => 'b-00',
			target  => '/etc/shorewall/policy',
			content => "\$FW all ACCEPT\n",
		}

		concat::fragment { 'policy-ipv4-drop-all-all':
			order   => 'z-99',
			target  => '/etc/shorewall/policy',
			content => "all all ${default_policy}\n",
		}
	
		# ip4 rules
		concat::fragment { 'rules-preamble':
			order   => '00',
			target  => '/etc/shorewall/rules',
			content => "# This file is managed by puppet\n# Changes will be lost\n",
		}

		concat::fragment { 'rule-ipv4-accept-ping':
			order   => '01',
			target  => '/etc/shorewall/rules',
			content => "Ping/ACCEPT all \$FW\n",
		}

		# ipv4 tunnels (composed)
		if $ipv4_tunnels {
			concat { '/etc/shorewall/tunnels':
				mode   => 0644,
				notify => Exec['shorewall-reload'],
			}

			concat::fragment { 'tunnels-preamble':
				order   => '00',
				target  => '/etc/shorewall/tunnels',
				content => "# This file is managed by puppet\n# Changes will be lost\n",
			}
		} else {
			file { '/etc/shorewall/tunnels':
				ensure => absent,
				notify => Exec['shorewall-reload'],
			}
		}

		# ipv4 masquerading
		concat::fragment { 'masq-preamble':
			order   => '00',
			target  => '/etc/shorewall/masq',
			content => "# This file is managed by puppet\n# Changes will be lost\n",
		}

		if $traffic_control {
			concat { [
					'/etc/shorewall/tcinterfaces',
					'/etc/shorewall/tcpri',
					'/etc/shorewall/tcrules',
				]:
				mode   => '0644',
				notify => Exec['shorewall-reload'],
			}

			# ipv4 tc interfaces
			concat::fragment { 'tcinterfaces-preamble':
				order   => '00',
				target  => '/etc/shorewall/tcinterfaces',
				content => "# This file is managed by puppet\n# Changes will be lost\n",
			}

			# ipv4 tc priorities
			concat::fragment { 'tcpri-preamble':
				order   => '00',
				target  => '/etc/shorewall/tcpri',
				content => "# This file is managed by puppet\n# Changes will be lost\n",
			}

			# ipv4 tc rules
			concat::fragment { 'tcrules-preamble':
				order   => '00',
				target  => '/etc/shorewall/tcrules',
				content => "# This file is managed by puppet\n# Changes will be lost\n",
			}
		} else {
			file { [
					'/etc/shorewall/tcinterfaces',
					'/etc/shorewall/tcpri',
					'/etc/shorewall/tcrules',
				]:
				ensure => absent,
			}
		}

		# ip4 shorewall.conf
		file { '/etc/shorewall/shorewall.conf':
			ensure  => present,
			content => template('shorewall/shorewall.conf.erb'),
			notify  => Exec['shorewall-reload'],
		}

		exec { 'shorewall-reload':
			command     => '/etc/init.d/shorewall restart',
			refreshonly => true,
		}
	}

	if $ipv6 {
		concat { [
				'/etc/shorewall6/zones',
				'/etc/shorewall6/interfaces',
				'/etc/shorewall6/policy',
				'/etc/shorewall6/rules',
			]:
			mode   => 0644,
			notify => Exec['shorewall6-reload'],
		}

		# ip6 zones
		concat::fragment { 'zones6-preamble':
			order   => '00',
			target  => '/etc/shorewall6/zones',
			content => "# This file is managed by puppet\n# Changes will be lost\n",
		}

		concat::fragment { 'shorewall6-zones-local':
			order   => '01',
			target  => '/etc/shorewall6/zones',
			content => "local firewall\n",
		}

		# ip6 interfaces
		concat::fragment { 'interfaces6-preamble':
			order   => '00',
			target  => '/etc/shorewall6/interfaces',
			content => "# This file is managed by puppet\n# Changes will be lost\n",
		}

		# ip6 policy (default DROP)
		concat::fragment { 'policy6-preamble':
			order   => 'a-00',
			target  => '/etc/shorewall6/policy',
			content => "# This file is managed by puppet\n# Changes will be lost\n",
		}
	
		concat::fragment { 'policy-ipv6-accept-outbound':
			order   => 'b-00',
			target  => '/etc/shorewall6/policy',
			content => "\$FW all ACCEPT\n",
		}

		concat::fragment { 'policy-ipv6-drop-all-all':
			order   => 'z-99',
			target  => '/etc/shorewall6/policy',
			content => "all all DROP\n",
		}
	
		# ip6 rules
		concat::fragment { 'rules6-preamble':
			order   => '00',
			target  => '/etc/shorewall6/rules',
			content => "# This file is managed by puppet\n# Changes will be lost\n",
		}

		concat::fragment { 'rule-ipv6-accept-ping':
			order   => '01',
			target  => '/etc/shorewall6/rules',
			content => "Ping/ACCEPT all \$FW\n",
		}

		# ipv6 tunnels
		if $ipv6_tunnels {
			concat { '/etc/shorewall6/tunnels':
				mode   => 0644,
				notify => Exec['shorewall6-reload'],
			}

			concat::fragment { 'tunnels6-preamble':
				order   => '00',
				target  => '/etc/shorewall6/tunnels',
				content => "# This file is managed by puppet\n# Changes will be lost\n",
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
