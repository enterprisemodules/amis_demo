require 'puppet_x/enterprisemodules/oracle/commands'
require 'easy_type'

Puppet::Type.type(:ora_service).provide(:oracle12) do
  include EasyType::Provider
  include Puppet_X::EnterpriseModules::Oracle::Commands

  confine :exists => '/etc/ora_setting.yaml'
  confine :feature => :oracle_running
  confine :feature => :oracle12

  desc 'Manage Oracle services using srvctl syntax for Oracle 12'

  mk_resource_methods

  def apply_clb_goal(value)
    "-clbgoal #{value}"
  end

  def apply_aq_ha_notifications(value)
    "-notification #{value}"
  end

  def apply_dtp(value)
    "-dtp #{value.to_s.upcase}"
  end

  def apply_failover_delay(value)
    "-failoverdelay #{value}"
  end

  def apply_failover_method(value)
    "-failovermethod #{value}"
  end

  def apply_failover_retries(value)
    "-failoverretry #{value}"
  end

  def apply_failover_type(value)
    "-failovertype #{value}"
  end

  def apply_lb_advisory(value)
    "-rlbgoal #{value}"
  end

  def apply_management_policy(value)
    # TODO
  end

  def apply_network_number(value)
    "-netnum #{value}"
  end

  def apply_server_pool(value)
    "-serverpool #{value.join(',')}"
  end

  def apply_service_role(value)
    "-role #{value}"
  end

  def create_preferred_instances(value)
    "-preferred #{value.join(',')}"
  end

  def update_preferred_instances(value)
    "-preferred #{value.join(',')}"
  end

  def apply_instances(value)
    "-available #{value.join(',')}" unless value.empty?
  end

  def apply_taf_policy(value)
    "-tafpolicy #{value}"
  end
end
