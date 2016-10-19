# ex: si ts=4 sw=4 et

define shorewall::mangle (
    $action,
    $source,
    $dest,
    $proto,
    $chain    = '',
    $port     = '-',
    $priority = '10',
) {
    include shorewall::defaults
    $mangle_filename = $::shorewall::defaults::mangle_filename

    $chain_suffix = $chain ? {
        ''      => '',
        default => ":${chain}"
    }

    concat::fragment { "mark-${source}-${dest}-${proto}-${port}":
        order   => $priority,
        target  => "/etc/shorewall/${mangle_filename}",
        content => "${action}${chain_suffix} ${source} ${dest} ${proto} ${port}\n",
    }
}
