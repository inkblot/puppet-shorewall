# shorewall

## Module Description

The shorewall module installs, configures and manages Shorewall firewalls. It supports both management of IPv4 as well as IPv6 rules.


## Example

```puppet
class { 'shorewall':
  # Install and manage 'shorewall'
  ipv4                => true,

  # Install and manage 'shorewall6'
  ipv6                => false,

  ipv4_tunnels        => false,
  ipv6_tunnels        => false,
  default_policy      => 'REJECT',
  ip_forwarding       => false,
  traffic_control     => false,
  maclist_ttl         => '',
  maclist_disposition => 'REJECT',
  log_martians        => true,
  route_filter        => true,
  default_zone_entry  => "local firewall\n",
  blacklist           => ["NEW","INVALID","UNTRACKED"]
}
```

## Types

* [Config shorewall::config](#Config)
* [Interfaces shorewall::iface](#Interface)
* [Zones shorewall::zone](#Zone)
* [Rules shorewall::rule](#Rule)
* [Tunnels shorewall::tunnel](#Tunnel)

### Config

Set a shorewall configuration option (internally uses Augeas).

```puppet
shorewall::config { 'SETTING_X':
    value => 'TRUE', # The value to set it to
    ipv4  => true,   # Set the value for ipv4 shorewall (Default: $::shorewall::ipv4)
    ipv6  => false   # Set the value for ipv4 shorewall (Default: $::shorewall::ipv6),
}
```

### Interface

Register a interface with a firewall zone or apply traffic shaping rules.

* [shorewall-interfaces](http://shorewall.net/manpages/shorewall-interfaces.html)
* [shorewall-interfaces6](http://shorewall.net/manpages/shorewall6-interfaces.html)
* [shorewall-tcinterfaces](http://shorewall.net/manpages/shorewall-tcinterfaces.html)

```puppet
shorewall::iface { 'eth0':
  interface     => 'eth0',    # Optional defaults to $name
  zone          => 'net'      # Name of the zone the interface gets assigned to
  proto         => 'ipv4',    # 'ipv4' or 'ipv6'
  options       = [],         # Any of the values mentioned under options shorewall doc

  # Options for tcinterfaces
  type          = 'External', # See tcinterfaces
  in_bandwidth  = '-',        # Incoming traffic shaping
  out_bandwidth = false,      # Outgoing traffic shaping
}
```

### Zone

Create a firewall zone.

* [shorewall-zones](http://shorewall.net/manpages/shorewall-zones.html)
* [shorewall6-zones](http://shorewall.net/manpages/shorewall6-zones.html)

```puppet
shorewall::zone { 'net':
  zone         => 'net',  # Optional, otherwise use $name
  parent_zones => [],     # List parent zones
  type         => 'ipv4', # See shorewall-zones type documentation (ipv4,ipv6,ipsec,firewall,loopback,..)
  options      = '-',     # See shorewall-zones options documentation
  in_options   = '-',     # See shorewall-zones options documentation
  out_options  = '-',     # See shorewall-zones options documentation
  order        = '50'
}
```

### Rule

Register a firewall rule.

* [shorewall-rules](http://shorewall.net/manpages/shorewall-rules.html)
* [shorewall6-rules](http://shorewall.net/manpages/shorewall6-rules.html)

```puppet
shorewall::rule { 'Allow Queries to Google DNS':
  application => 'DNS',
  action      => 'ACCEPT',
  source      => '$FW',
  dest        => 'net:8.8.8.8',
  ipv4        => true,
  ipv6        => false,
  order       => '50',
}
```

Alternatively if there doesn't exist a shorewall macro for the application, you can specify proto/ports manually.

```puppet
shorewall::rule { 'Allow Queries to Google DNS':
  source => '$FW',
  dest   => 'net:8.8.8.8',
  proto  => 'udp',
  port   => '53',
  ipv4   => true,
  ipv6   => false,
  order  => '50',
}
```

### Tunnel

Define rules for encapsulated traffic.

* [shorewall-tunnels](http://shorewall.net/manpages/shorewall-tunnels.html)
* [shorewall6-tunnels](http://shorewall.net/manpages/shorewall6-tunnels.html)

```puppet
shorewall::tunnel { 'office':
    proto   => 'ipv4',
    type    => 'ipsec',
    zone    => 'net',
    gateway => '0.0.0.0/0',
}
```

### Blacklist
TBD

### Host
TBD

### Mark
TBD

### Policy
TBD

### Port
TBD

### Proxyarp
TBD

### Routestopped
TBD

## Simple
TBD
