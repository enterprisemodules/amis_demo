#
# Default features are not rechecked. SO that is why we do the difficult solution.
# Check https://tickets.puppetlabs.com/browse/PUP-5985?jql=text~%22feature%20evaluation%22
#
require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/settings'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/information'

module OracleFeature
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::Settings
  include Puppet_X::EnterpriseModules::Oracle::Information

  def self.sid
    default_database_sid
  end

  def self.oracle12_check
    Puppet.debug 'Checking Oracle 12 available'
    Puppet.debug "sid is #{sid}"
    Puppet.debug "Database version is #{database_version}"

    if sid && /^12.*$/.match(database_version)
      Puppet.debug 'Oracle 12 available'
      true
    else
      Puppet.debug 'Oracle 12 **NOT** available'
      false
    end
  rescue => e
    Puppet.debug e # Show the generated error
    Puppet.debug 'Oracle 12 **NOT** available'
    false
  end

  Puppet.features.add(:oracle12) do
    oracle12_check
  end

  Puppet.features.send :meta_def, 'oracle12?' do
    name = :oracle12
    final = @results[name]
    @results[name] = OracleFeature.oracle12_check unless final
    @results[name]
  end
end
