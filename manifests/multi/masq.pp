# ex:ts=4 sw=4 tw=72

define shorewall::multi::masq (
	$interface,
	$sources,
) {

	concat::fragment { "masq-${interface}-${sources}":
		order   => '50',
		target  => '/etc/shorewall/masq',
		content => inline_template("<%= interface %> <%= sources.join(',') %>\n"),
	}

}	
