# ex: si ts=4 sw=4 et

define shorewall::conntrack (
    $proto         = '',
    $port          = '',
    $sport         = '',
    $user          = '',
    $switch        = '',
    $source,
    $dest,
    $action,
    $ipv4          = $::shorewall::ipv4,
    $ipv6          = $::shorewall::ipv6,
    $order         = '50',
) {
    if $proto != '' {
    validate_re($proto, '^(([0-9]+|tcp|udp|icmp|-)(?:,|$))+')
    }
    if $port != '' {
        validate_re($port, ['^:?[0-9]+:?$', '^-$', '^[0-9]+[:,][0-9]+$'])
        validate_re($proto, '^(([0-9]+|tcp|udp|icmp|-)(?:,|$))+')
    }

    validate_re($action, '^(NOTRACK|DROP|IPTABLES\(.*\)|LOG|NFLOG|ULOG|(CT\:helper\:[amanda|ftp|RAS|Q\.931|irc|netbios\-ns|pptp|sane|sip|snmp|tftp]+)|CT\:notrack)(\(expevents\=new\)|\(ctevents\:[new|related|destroy|reply|assured|protoinfo|helper|mark|natseqinfo|secmark|,]+\))?(\:[P|O|PO|OP]+)?')

    if $sport != '' {
      validate_re($sport, '[^\s]+')
    }
    if $user != '' {
        validate_re($user, '\w+')
    }
    if $switch != '' {
      validate_re($switch,'^\!?[a-z|A-Z]{1}[\w]+(\=[0|1])?')
    }

    if $ipv4 {
        concat::fragment { "conntrack-rule-ipv4-${name}":
            order   => $order,
            target  => '/etc/shorewall/conntrack',
            content => template('shorewall/conntrack.erb'),
        }
    }

    if $ipv6 {
        concat::fragment { "conntrack-rule-ipv6-${name}":
            order   => $order,
            target  => '/etc/shorewall6/conntrack',
            content => template('shorewall/conntrack.erb'),
        }
    }
}
