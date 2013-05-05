# ex:ts=4 sw=4 tw=72

define shorewall::multi::port (
	$proto,
	$port,
	$source,
	$action = 'ACCEPT',
	$order  = '50',
) {
	shorewall::multi::rule {
		proto  => $proto,
		port   => $port,
		source => $source,
		dest   => '$FW',
		action => $action,
		order  => $order,
	}
}
