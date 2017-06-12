#
# Default features are not rechecked. SO that is why we do the difficult solution.
# Check https://tickets.puppetlabs.com/browse/PUP-5985?jql=text~%22feature%20evaluation%22
#
require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'

module OracleFeature
  def self.oratab_file
    case Facter.value(:osfamily)
    when 'RedHat'
      '/etc/oratab'
    when 'Solaris'
      '/var/opt/oracle/oratab'
    else
      fail 'error unsupported OS'
    end
  end

  def self.oratab_exists
    Puppet.debug 'Checking if oratab exists'

    if File.exists?(oratab_file)
      Puppet.debug "File #{oratab_file} available"
      true
    else
      Puppet.debug "File #{oratab_file} **NOT** available"
      false
    end
  end

  Puppet.features.add(:oratab_exists) do
    oratab_exists
  end

  Puppet.features.send :meta_def, 'oratab_exists?' do
    name = :oracle11
    final = @results[name]
    @results[name] = OracleFeature.oratab_exists unless final
    @results[name]
  end
end
