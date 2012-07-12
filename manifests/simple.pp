# ex:ts=4 sw=4 tw=72

class shorewall::simple (
	$ip_iface  = 'eth0',
	$ip6_iface = false,
	$dynamic   = true,
) inherits shorewall::base {
	if !$ip_iface and !$ip6_iface {
		fail("$::fqdn must specify either ip_iface or ip6_iface for shorewall::simple")
	}

	if $ip_iface {
		# zones (just inet)
		file { '/etc/shorewall/zones':
			mode    => 0644,
			content => "local firewall\ninet ipv4\n",
			require => Package['shorewall'],
		}
		# interfaces (just one)
		file { '/etc/shorewall/interfaces':
			mode    => 0644,
			content => inline_template("inet <%= ip_iface %> detect tcpflags,nosmurfs,routefilter<%= dynamic ? ',dhcp,optional' : '' %>\n"),
			require => Package['shorewall'],
		}
		# policy (default DROP)
		file { '/etc/shorewall/policy':
			mode    => 0644,
			content => "\$FW all ACCEPT\ninet all drop info\nall all REJECT info\n",
			require => Package['shorewall'],
		}
		
		# rules (composed)
		file { '/etc/shorewall/rules':
			mode    => 0644,
			content => "Ping/ACCEPT all $FW\n",
			require => Package['shorewall'],
		}

		# shorewall.conf
		file { '/etc/shorewall/shorewall.conf':
			ensure  => present,
			require => Package['shorewall'],
		}
	}

	if $ip6_iface {
		# zones (just inet)
		# interfaces (just one)
		# policy (default DROP)
		# rules (composed)
		# shorewall.conf
	}
}
