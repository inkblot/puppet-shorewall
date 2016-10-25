# ex: si ts=4 sw=4 et

define shorewall::mark (
    $value,
    $source,
    $dest,
    $proto,
    $chain    = '',
    $port     = '-',
    $priority = '10',
) {
    include shorewall::defaults
    $mangle_filename = $::shorewall::defaults::mangle_filename

    $action = $mangle_filename ? {
        "tcrules" => $value,
        "mangle"  => "MARK(${value})"
    }

    shorewall::mangle { "mark-${source}-${dest}-${proto}-${port}":
        action   => $action,
        source   => $source,
        dest     => $dest,
        proto    => $proto,
        chain    => $chain,
        port     => $port,
        priority => $priority,
    }
}
