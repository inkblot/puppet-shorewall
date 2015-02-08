# ex: si ts=4 sw=4 et

define shorewall::simple::port (
    $proto,
) {
    shorewall::port { "port-${name}-proto":
        proto  => $proto,
        port   => $name,
        source => $::shorewall::simple::inet,
    }
}
