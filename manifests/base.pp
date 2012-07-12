# ex:ts=4 sw=4 tw=72

class shorewall::base (
) {

	include shorewall::install

	file { '/etc/default/shorewall':
		ensure => present,
		mode   => 0644,
		source => 'puppet:///modules/puppet/etc/default/shorewall',
	}

	file { '/etc/default/shorewall6':
		ensure => present,
		mode   => 0644,
		source => 'puppet:///modules/puppet/etc/default/shorewall6',
	}

}
