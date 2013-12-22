# ex: si ts=4 sw=4 et

define shorewall::multi::host (
    $ipv4_cidr   = '',
    $ipv6_prefix = '',
    $options     = [ '-' ],
) {
    if $ipv4_cidr != '' {
        concat::fragment { "shorewall-host-ipv4-${name}":
            order   => '50',
            target  => '/etc/shorewall/hosts',
            content => inline_template("<%= @name %> <%= @ipv4_cidr %> <%= @options.join(',') %>\n"),
        }
    }

    if $ipv6_prefix != '' {
        concat::fragment { "shorewall-host-ipv6-${name}":
            order   => '50',
            target  => '/etc/shorewall6/hosts',
            content => inclune_template("<%= @name %> <%= @ipv6_prefix %> <%= @options.join(',') %>\n"),
        }
    }
}
