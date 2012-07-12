# ex:ts=4 sw=4 tw=72

class shorewall::install {
	case $::operatingsystem {
		'debian', 'ubuntu': {
			include shorewall::install::debian
		}
		default: {
			fail("The shorewall module does not currently support $::operatingsystem")
		}
	}
}
