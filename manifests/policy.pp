# ex: si ts=4 sw=4 et

define shorewall::policy (
    $priority,
    $source,
    $dest,
    $action,
    $log_level = '-',
    $ipv4      = $::shorewall::ipv4,
    $ipv6      = $::shorewall::ipv6,
) {
    if $ipv4 {
        concat::fragment { "policy-ipv4-${action}-${source}-to-${dest}":
            order   => "p-${priority}",
            target  => '/etc/shorewall/policy',
            content => "${source} ${dest} ${action} ${log_level}\n",
        }
    }

    if $ipv6 {
        concat::fragment { "policy-ipv6-${action}-${source}-to-${dest}":
            order   => "p-${priority}",
            target  => '/etc/shorewall6/policy',
            content => "${source} ${dest} ${action} ${log_level}\n",
        }
    }
}
