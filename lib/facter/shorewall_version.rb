require 'facter'
Facter.add(:shorewall_version) do
  version = 0
  Facter::Util::Resolution.exec('shorewall version').split('.', 3).each do |v|
     version = version * 100 + v.to_i
  end
  setcode { version }
end
require 'facter'
Facter.add(:shorewall6_version) do
  version = 0
  Facter::Util::Resolution.exec('shorewall6 version').split('.', 3).each do |v|
     version = version * 100 + v.to_i
  end
  setcode { version }
end
