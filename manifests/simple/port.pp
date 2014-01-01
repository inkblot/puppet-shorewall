# ex: si ts=4 sw=4 et

define shorewall::simple::port (
    $proto,
    $port,
) {
    shorewall::port { $name:
        proto  => $proto,
        port   => $port,
        source => $shorewall::simple::inet,
    }
}
