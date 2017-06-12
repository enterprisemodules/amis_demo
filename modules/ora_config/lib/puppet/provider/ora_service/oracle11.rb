require 'puppet_x/enterprisemodules/oracle/commands'
require 'easy_type'

Puppet::Type.type(:ora_service).provide(:oracle11) do
  include EasyType::Provider
  include Puppet_X::EnterpriseModules::Oracle::Commands

  confine :exists => '/etc/ora_setting.yaml'
  confine :feature => :oracle_running
  confine :feature => :oracle11

  desc 'Manage Oracle services using srvctl syntax in Oracle 11 provider.'

  mk_resource_methods

  def apply_clb_goal(value)
    "-j #{value}"
  end

  def apply_aq_ha_notifications(value)
    "-q #{value}"
  end

  def apply_lb_advisory(value)
    "-B #{value}"
  end

  def apply_dtp(value)
    "-x #{value}"
  end

  def apply_failover_delay(value)
    "-w #{value}"
  end

  def apply_failover_method(value)
    "-m #{value}"
  end

  def apply_failover_retries(value)
    "-z #{value}"
  end

  def apply_failover_type(value)
    "-e #{value}"
  end

  def apply_management_policy(value)
    "-y #{value}"
  end

  def apply_server_pool(value)
    "-g '#{value.join(',')}'"
  end

  def apply_service_role(value)
    "-l #{value}"
  end

  def apply_taf_policy(value)
    "-P #{value}"
  end

  def apply_available_instances(value)
    "-a '#{value.join(',')}'"
  end

  def create_preferred_instances(value)
    "-r '#{value.join(',')}'"
  end

  def update_preferred_instances(value)
    "-n -i '#{value.join(',')}'"
  end

end
