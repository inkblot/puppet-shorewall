# ex:ts=4 sw=4 tw=72

class shorewall::install (
	$ipv4,
	$ipv6,
) {
	case $::operatingsystem {
		'debian', 'ubuntu': {
			class { 'shorewall::install::debian':
				ipv4 => $ipv4,
				ipv6 => $ipv6,
			}
		}
		default: {
			fail("The shorewall module does not currently support $::operatingsystem")
		}
	}
}
