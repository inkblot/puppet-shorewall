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

    if $type != 'ipv6' and $::shorewall::ipv4 {
        if versioncmp($::shorewall_version, '4.4.25') < 0 {
            $blacklist_filename = 'blacklist'
        } else {
            $blacklist_filename = 'blrules'
        }

        concat::fragment { "${blacklist_filename}-ipv4-${name}":
            order   => $order,
            target  => "/etc/shorewall/${blacklist_filename}",
            content => template("shorewall/${blacklist_filename}.erb"),
        }
    }

    if $type != 'ipv4' and $::shorewall::ipv6 {
        if versioncmp($::shorewall6_version, '4.4.25') < 0 {
            $blacklist6_filename = 'blacklist'
        } else {
            $blacklist6_filename = 'blrules'
        }

        concat::fragment { "${blacklist6_filename}-ipv6-${name}":
            order   => $order,
            target  => "/etc/shorewall6/${blacklist6_filename}",
            content => template("shorewall/${blacklist6_filename}.erb"),
        }
    }
}
