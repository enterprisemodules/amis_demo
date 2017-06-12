require 'facter'
require 'puppet'
#
# Pass the name of the Puppet setting confdir as a fact
#
Facter.add('puppet_confdir') do
  setcode do
    Puppet.settings[:confdir]
  end
end
