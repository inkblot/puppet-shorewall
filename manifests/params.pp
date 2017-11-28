class shorewall::params {
  $config_test = false

  # OS Dependant variables
  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        /^[5|6]$/: {
          # EL6 is doing proper shorewall restart by issuing `shorewall restart`
          $service_restart  = '/sbin/service shorewall restart'
          $service6_restart = '/sbin/service shorewall6 restart'
        }
        default: {
          $service_restart  = '/usr/sbin/shorewall check && /bin/systemctl restart shorewall'
          $service6_restart = '/usr/sbin/shorewall6 check && /bin/systemctl restart shorewall6'
        }
      }
    } # RedHat

    default: {
      $service_restart  = '/usr/sbin/shorewall check && /bin/systemctl restart shorewall'
      $service6_restart = '/usr/sbin/shorewall6 check && /bin/systemctl restart shorewall6'
  }
}
