

define shorewall::config (
    $value,
    $ipv4          = $::shorewall::ipv4,
    $ipv6          = $::shorewall::ipv6,
) {

    if $ipv4 {
      augeas { "shorewall-set-ipv4-$name":
        changes => "set /files/etc/shorewall/shorewall.conf/$name '$value'",
        lens    => 'Shellvars.lns',
        incl    => '/etc/shorewall/shorewall.conf',
        notify  => Service['shorewall'],
        require => Package['shorewall'],
      }
    }

    if $ipv6 {
      augeas { "shorewall-set-ipv6-$name":
        changes => "set /files/etc/shorewall6/shorewall6.conf/$name '$value'",
        lens    => 'Shellvars.lns',
        incl    => '/etc/shorewall/shorewall6.conf',
        notify  => Service['shorewall6'],
        require => Package['shorewall6'],
      }
    }
}
