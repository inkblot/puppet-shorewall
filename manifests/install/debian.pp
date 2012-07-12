# ex:tx=4 sw=4 tw=72

class shorewall::install::debian {
	package { [ 'shorewall', 'shorewall6' ]:
		ensure => latest,
	}
}
