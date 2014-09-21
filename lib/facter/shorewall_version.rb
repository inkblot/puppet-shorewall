require 'facter'
if File.exists?("/sbin/shorewall")
  Facter.add(:shorewall_version) do
    version = 0
    Facter::Util::Resolution.exec('shorewall version').split('.', 3).each do |v|
      version = version * 100 + v.to_i
    end
    setcode { version }
  end
end
require 'facter'
if File.exists?("/sbin/shorewall6")
  Facter.add(:shorewall6_version) do
    version = 0
    Facter::Util::Resolution.exec('shorewall6 version').split('.', 3).each do |v|
      version = version * 100 + v.to_i
    end
    setcode { version }
  end
end
