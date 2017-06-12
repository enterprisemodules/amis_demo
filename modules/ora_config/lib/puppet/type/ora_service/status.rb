newproperty(:status) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::Commands
  include Puppet_X::EnterpriseModules::Oracle::Information

  desc <<-EOD
    The state of the service. It can be either running or stopped.
  EOD

  newvalues(:running, :stopped)
  defaultto :running

  to_translate_to_resource do |raw_resource|
    sid = raw_resource['SID']
    if cluster?(sid)
      name = raw_resource['NAME'].upcase
      cluster_service_running_on(name, sid).empty? ? :stopped : :running
    else
      :running
    end
  end

  after_create do
    return true unless cluster?(resource.sid)
    after_modify
  end

  after_modify do
    case resource[:status]
    when :stopped
      stop_service
    when :running
      start_service
    else
      fail 'internal error. Invalid status found'
    end
  end

  def sid
    resource.sid
  end

  def insync?(_is)
    return true unless cluster?
    if should == :running
      all_started?
    else
      all_stopped?
    end
  end

  def start_service
    srvctl("start service -d #{database} -s #{resource[:service_name]}", :sid => sid)
  end

  def stop_service
    srvctl("stop service -d #{database} -s #{resource[:service_name]}", :sid => sid)
  end

  def all_started?
    cluster_service_running_on.sort == preferred_instances.sort
  end

  def all_stopped?
    cluster_service_stopped_on.sort == preferred_instances.sort
  end

  def cluster_service_running_on
    self.class.cluster_service_running_on(resource[:service_name], resource[:sid])
  end

  def cluster_service_stopped_on
    preferred_instances - cluster_service_running_on
  end

  def self.cluster_service_running_on(name, local_sid = sid)
    running_on = status_string(local_sid).scan(/Service #{name} is running on instance\(s\) (.*)$/).first
    if running_on
      running_on.first.split(',')
    else
      []
    end
  end

  def self.status_string(sid)
    @status_string ||= srvctl("status service -d #{database(sid)}", :sid => sid)
  end

  def preferred_instances
    resource[:preferred_instances] ? resource[:preferred_instances] : cluster_instances
  end

  def database
    self.class.database(resource.sid)
  end

  def self.database(sid)
    if sid =~ /.*\d$/
      sid[0, sid.size - 1]
    else
      sid
    end
  end
end
