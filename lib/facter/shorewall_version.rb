require 'facter'
Facter.add(:shorewall_version) do
  version = 0
  if File.exists?("/sbin/shorewall")
    version = Facter::Util::Resolution.exec('shorewall version')
  end
  setcode { version }
end
require 'facter'
Facter.add(:shorewall6_version) do
  version = 0
  if File.exists?("/sbin/shorewall6")
    version = Facter::Util::Resolution.exec('shorewall6 version')
  end
  setcode { version }
end
