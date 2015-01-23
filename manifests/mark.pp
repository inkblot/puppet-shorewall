# ex: si ts=4 sw=4 et

define shorewall::mark (
    $value,
    $source,
    $dest,
    $proto,
    $priority = '10',
) {
    concat::fragment { "mark-${source}-${dest}-${proto}":
        order   => $priority,
        target  => '/etc/shorewall/mangle',
        content => "MARK(${value}) ${source} ${dest} ${proto}\n",
    }
}
