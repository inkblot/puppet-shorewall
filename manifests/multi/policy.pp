# ex: si ts=4 sw=4 et

define shorewall::multi::policy (
    $priority,
    $source,
    $dest,
    $action,
    $log_level = '-'
) {
    if $shorewall::multi::ipv4 {
        concat::fragment { "policy-ipv4-${action}-${source}-to-${dest}":
            order   => "p-${priority}",
            target  => '/etc/shorewall/policy',
            content => "${source} ${dest} ${action} ${log_level}\n",
        }
    }

    if $shorewall::multi::ipv6 {
        concat::fragment { "policy-ipv6-${action}-${source}-to-${dest}":
            order   => "p-${priority}",
            target  => '/etc/shorewall6/policy',
            content => "${source} ${dest} ${action} ${log_level}\n",
        }
    }
}
