# ex: si ts=4 sw=4 et

define shorewall::proxyarp (
    $interface,
    $external,
    $haveroute = 'No',
    $persistent = 'No',
    $address = '',
) {
    $address_name = $address ? {
        '' => $name,
        default => $address,
    }

    concat::fragment { "proxyarp-${name}":
        order   => '50',
        target  => '/etc/shorewall/proxyarp',
        content => template('shorewall/proxyarp.erb')
    }

}
