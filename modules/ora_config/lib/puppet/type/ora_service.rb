require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'easy_type/array_property'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/commands'
require 'puppet_x/enterprisemodules/oracle/information'
require 'puppet_x/enterprisemodules/oracle/service_property'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_service) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::Commands
  include Puppet_X::EnterpriseModules::Oracle::Information
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This resource allows you to manage a service in an Oracle database.

    It has support for serices on single instance databases, but also supports
    creating services on a RAC cluster.  Here is an example on setting a service
    on a RAC cluster.

        ora_service { 'MYSERVICE.DEVELOPMENT.ORG@SID1':
          ensure              => 'present',
          aq_ha_notifications => 'false',
          clb_goal            => 'LONG',
          dtp                 => 'false',
          failover_delay      => '0',
          failover_method     => 'NONE',
          failover_retries    => '0',
          failover_type       => 'NONE',
          lb_advisory         => 'THROUGHPUT',
          management_policy   => 'AUTOMATIC',
          preferred_instances => ['O2DEVEL1'],
          server_pool         => ['O2DEVEL_STAM.DEVELOPMENT.ORG'],
          service_role        => 'PRIMARY',
          status              => 'running',
          taf_policy          => 'NONE',
        }

    On a single instance Oracle database, most of the above options are ignored. So a simple version
    of the manifest for such a database would be:

        ora_service { 'MYSERVICE.DEVELOPMENT.ORG@SID1':
          ensure              => 'present',
        }

    `ora_service` doesn't manage the internal services created by Oracle.

  EOD

  #
  # The local services will be filtered from the list of services and
  # will not be reported by Puppet.
  #
  LOCAL_SERVICES = ['SYS$BACKGROUND', 'SYS$USERS'].freeze

  ensurable

  #
  # The information metodes need a default sid. Here it is.
  #
  def self.sid
    default_database_sid
  end

  validate do
    invalid_names = LOCAL_SERVICES + ["#{sid}XDB".upcase]
    fail "#{service_name} is a reserved service and cannot be managed with puppet" if invalid_names.include?(service_name)
  end

  to_get_raw_resources do
    all_services = cluster?(sid) ? global_service_list : local_service_list
    found_sids = all_services.collect{|s| s['SID']}.uniq
    exclude_services = found_sids.collect do |sid|
      ["#{sid}XDB".upcase]
    end.flatten
    #
    # Filter local services
    #
    local_services = LOCAL_SERVICES + exclude_services
    all_services.reject { |s| local_services.include?(s['NAME'].upcase) }
  end

  on_create do
    if cluster?
      #
      # We need the preferred_instances to be set. We set it to an empty
      # array. We do this here because when we set it as a default, we generates
      # an warning when we are not on a cluster. When we do it here, no warining
      # is issues, but the on_create action in the property is called
      #
      self[:preferred_instances] = [] if self[:preferred_instances].nil?
      [:srvctl, "add service -d #{dbname} -s #{service_name}", {:sid => sid}]
    else
      create_service
      nil
    end
  end

  on_modify do
    if cluster?
      [:srvctl, "modify service -d #{dbname} -s #{service_name}", { :skip_without_properties => true, :sid => sid }]
    else
      modify_service
      nil
    end
  end

  on_destroy do
    disconnect_service
    if cluster?
      remove_cluster_service
    else
      remove_service
    end
    nil
  end

  map_title_to_sid(:service_name)

  parameter :name
  parameter :service_name
  parameter :sid
  property  :status
  property  :available_instances
  property  :preferred_instances
  property  :clb_goal
  property  :aq_ha_notifications
  property  :dtp
  property  :failover_delay
  property  :failover_method
  property  :failover_retries
  property  :failover_type
  property  :lb_advisory
  property  :management_policy
  property  :server_pool
  property  :service_role
  property  :taf_policy

  private

  def self.database
    if sid =~ /.*\d$/
      sid[0, sid.size - 1]
    else
      sid
    end
  end

  def disconnect_service
    sql "exec dbms_service.disconnect_session('#{service_name}')", :sid => sid, :failonsqlfail => false, :parse => false
  end

  def delete_service
    sql "exec dbms_service.delete_service('#{service_name}')", :sid => sid, :failonsqlfail => false, :parse => false
  end

  def self.local_service_list
    sql_on_all_database_sids template('ora_config/ora_service/index.sql.erb', binding)
  end

  def self.global_service_list
    service_info_text = srvctl "config service -d #{sid.chop}", :sid => sid
    #
    # Oracle 11 doesn't include a new line between the service definitions
    # so we force one.
    #
    service_info_text = service_info_text.gsub(/Service name:/, "\nService name:") + "\n"
    service_info_list = service_info_text.scan(/(Service name: .*?$.*?^$)/m).flatten
    service_info_list.collect do |service_info|
      info = service_info.scan(/^(.*)\s?:(.*)$/).flatten + ['SID', sid]
      values = EasyType::Helpers::InstancesResults[info.map(&:strip).each_slice(2).to_a]
      values['NAME'] = values['Service name'] # Used for compatibility between cluster and non cluster
      values
    end
  end

  def create_service
    sql "exec dbms_service.create_service('#{service_name}', '#{service_name}')", :sid => sid, :failonsqlfail => false, :parse => false
    if containerdb? && rootdb?
      new_services = current_services << service_name
      statement = set_services_command(new_services)
      sql statement, :sid => sid
    end
  end

  def remove_service
    sql "exec dbms_service.delete_service('#{service_name}')", :sid => sid, :failonsqlfail => false, :parse => false
    if containerdb? && rootdb?
      current_services.delete(service_name)
      statement = set_services_command(current_services)
      sql statement, :sid => sid
    end
  end

  def remove_cluster_service
    srvctl "remove service -d #{dbname} -s #{service_name} -f", :sid => sid
  end

  def set_services_command(services)
    "alter system set service_names = '#{services.join('\',\'')}' scope=both"
  end

  def current_services
    @current_services ||= provider.class.instances.map(&:service_name).dup
  end

  def modified?(property)
    property.resource.provider.property_flush[property.name]
  end

  def ensure_cluster_service_status
    properties.select { |p| p.name == :status }.first.on_modify(nil)
  end

  def dbname
    sid ? sid.chop : default_database_sid.chop
  end
end
