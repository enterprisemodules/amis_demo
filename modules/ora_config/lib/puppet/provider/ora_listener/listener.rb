require 'puppet_x/enterprisemodules/oracle/access'

Puppet::Type.type(:ora_listener).provide(:listener) do
  include Puppet_X::EnterpriseModules::Oracle::Access

  def self.instances
    []
  end

  def listener(action)
    db_sid = resource.name
    command = "su - oracle -c 'export ORACLE_SID=#{db_sid};export ORAENV_ASK=NO;. oraenv;lsnrctl #{action}'"
    execute command, :failonfail => false, :override_locale => false, :squelch => true
  end

  def start
    listener :start
  end

  def stop
    listener :stop
  end

  def status
    listener :status
    return :running if $CHILD_STATUS.exitstatus == 0
    :stopped
  end
end
