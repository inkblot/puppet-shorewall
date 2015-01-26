# ex: si ts=4 sw=4 et

define shorewall::mark (
    $value,
    $source,
    $dest,
    $proto,
    $port     = '-',
    $priority = '10',
) {
    concat::fragment { "mark-${source}-${dest}-${proto}-${port}":
        order   => $priority,
        target  => '/etc/shorewall/tcrules',
        content => "${value} ${source} ${dest} ${proto} ${port}\n",
    }
}
