# ex: si ts=4 sw=4 et

define shorewall::policy (
    $source,
    $dest,
    $action,
    $priority  = '50',
    $log_level = '-',
    $ipv4      = $::shorewall::ipv4,
    $ipv6      = $::shorewall::ipv6,
) {
    validate_re($priority, ['^\d+$','last'], 'Valid values for $priority are any integer or \'last\'.')

    if $priority == 'last' {
        $order = 'q-last'
    } else {
        $order = "p-${priority}"
    }

    if $ipv4 {
        concat::fragment { "policy-ipv4-${action}-${source}-to-${dest}":
            order   => $priority,
            target  => '/etc/shorewall/policy',
            content => "${source} ${dest} ${action} ${log_level}\n",
        }
    }

    if $ipv6 {
        concat::fragment { "policy-ipv6-${action}-${source}-to-${dest}":
            order   => $priority,
            target  => '/etc/shorewall6/policy',
            content => "${source} ${dest} ${action} ${log_level}\n",
        }
    }
}
