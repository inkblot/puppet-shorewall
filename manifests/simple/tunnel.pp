# ex: si ts=4 sw=4 et

define shorewall::simple::tunnel (
    $proto   = 'ipv4',
    $type,
    $gateway = '0.0.0.0/0',
) {
    shorewall::tunnel { $name:
        proto   => $proto,
        type    => $type,
        gateway => $gateway,
        zone    => $shorewall::simple::inet,
    }
}
