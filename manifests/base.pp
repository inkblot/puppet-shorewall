# ex:ts=4 sw=4 tw=72

class shorewall::base (
	$ipv4,
	$ipv6,
) {

	include concat::setup

	File {
		ensure => present,
		owner  => 'root',
		group  => 'root',
	}

	class { 'shorewall::install':
		ipv4 => $ipv4,
		ipv6 => $ipv6,
	}

	if $ipv4 {
		file { '/etc/shorewall':
			ensure  => directory,
			require => Package['shorewall'],
		}

		file { '/etc/default/shorewall':
			mode   => '0644',
			source => 'puppet:///modules/shorewall/etc/default/shorewall',
		}
	}

	if $ipv6 {
		file { '/etc/shorewall6':
			ensure  => directory,
			require => Package['shorewall6'],
		}

		file { '/etc/default/shorewall6':
			mode   => '0644',
			source => 'puppet:///modules/shorewall/etc/default/shorewall6',
		}
	}

}
