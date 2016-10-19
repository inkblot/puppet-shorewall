# ex: si ts=4 sw=4 et

define shorewall::blacklist (
    $action        = 'DROP',
    $type          = 'ipv4',
    $source        = 'all',
    $address       = '',
    $dest          = '$FW',
    $proto         = '',
    $port          = [],
    $order         = '50',
) {
    validate_re($proto, '^([0-9]+|tcp|udp|-)$')

    include shorewall::defaults

    $blacklist_filename = $::shorewall::defaults::blacklist_filename

    if $type != 'ipv6' and $::shorewall::ipv4 {
        concat::fragment { "${blacklist_filename}-ipv4-${name}":
            order   => $order,
            target  => "/etc/shorewall/${blacklist_filename}",
            content => template("shorewall/${blacklist_filename}.erb"),
        }
    }

    if $type != 'ipv4' and $::shorewall::ipv6 {
        concat::fragment { "${blacklist_filename}-ipv6-${name}":
            order   => $order,
            target  => "/etc/shorewall6/${blacklist_filename}",
            content => template("shorewall/${blacklist_filename}.erb"),
        }
    }
}
