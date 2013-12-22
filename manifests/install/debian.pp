# ex: si ts=4 sw=4 et

class shorewall::install::debian (
	$ipv4,
	$ipv6
) {
	if $ipv4 {
		package { 'shorewall':
			ensure => latest,
		}
	}

	if $ipv6 {
		package { 'shorewall6':
			ensure => latest,
		}
	}
}
