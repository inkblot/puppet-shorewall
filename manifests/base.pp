# ex:ts=4 sw=4 tw=72

class shorewall::base (
) {

	include concat::setup
	include shorewall::install

	file { '/etc/default/shorewall':
		ensure => present,
		mode   => 0644,
		source => 'puppet:///modules/shorewall/etc/default/shorewall',
	}

	file { '/etc/default/shorewall6':
		ensure => present,
		mode   => 0644,
		source => 'puppet:///modules/shorewall/etc/default/shorewall6',
	}

}
