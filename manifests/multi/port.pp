# ex:ts=4 sw=4 tw=72

define shorewall::multi::port (
	$application = '',
	$proto       = '',
	$port        = -1,
	$source,
	$action      = 'ACCEPT',
	$order       = '50',
) {
	shorewall::multi::rule { "port-${name}":
		application => $application,
		proto       => $proto,
		port        => $port,
		source      => $source,
		dest        => '$FW',
		action      => $action,
		order       => $order,
	}
}
