# ex: si ts=4 sw=4 et

define shorewall::multi::rule (
	$application = '',
	$proto       = '',
	$port        = -1,
	$source,
	$dest,
	$action,
	$order  = '50',
) {
	if $shorewall::multi::ipv4 {
		if $application != '' {
			concat::fragment { "rule-ipv4-${source}-to-${dest}-${application}":
				order   => $order,
				target  => '/etc/shorewall/rules',
				content => "${application}/${action} ${source} ${dest}\n",
			}
		} elsif $proto != '' and $port != -1 {
			concat::fragment { "rule-ipv4-${source}-to-${dest}-${proto}-${port}":
				order   => $order,
				target  => '/etc/shorewall/rules',
				content => "${action} ${source} ${dest} ${proto} ${port}\n",
			}
		} else {
			fail("Shorewall::Multi::Rule[${name}] requires either a proto and port or an application")
		}
	}

	if $shorewall::multi::ipv6 {
		if $application != '' {
			concat::fragment { "rule-ipv6-${source}-to-${dest}-${application}":
				order   => $order,
				target  => '/etc/shorewall6/rules',
				content => "${application}/${action} ${source} ${dest}\n",
			}
		} elsif $proto != '' and $port != -1 {
			concat::fragment { "rule-ipv6-${source}-to-${dest}-${proto}-${port}":
				order   => $order,
				target  => '/etc/shorewall6/rules',
				content => "${action} ${source} ${dest} ${proto} ${port}\n",
			}
		} else {
			fail("Shorewall::Multi::Rule[${name}] requires either a proto and port or an application")
		}
	}
}
