# ex: si ts=4 sw=4 et

define shorewall::port (
    $application = '',
    $proto       = '',
    $port        = '',
    $source,
    $action      = 'ACCEPT',
    $order       = '50',
) {
    shorewall::rule { "port-${name}":
        application => $application,
        proto       => $proto,
        port        => $port,
        source      => $source,
        dest        => '$FW',
        action      => $action,
        order       => $order,
    }
}
