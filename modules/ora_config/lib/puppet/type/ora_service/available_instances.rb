newproperty(:available_instances, :array_matching => :all) do
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty
  include EasyType::ArrayProperty

  desc <<-EOD
    A list of instance names to activate the service on.

    Here is an example on how to use this:

        ora_service{'my_service':
          ...
          available_instances => ['SID1', 'SID2', 'SID3'],
          ...
        }

    When an instance is specfied that does not or not yes exist in the cluster, Puppet will
    ignore it.

  EOD

  column_name 'Available instances'

  def insync?(is)
    if cluster?
      super(is)
    else
      Puppet.warning "#{path}: #{name} has no effect on non clustered service."
    end
  end

  to_translate_to_resource do |raw_resource|
    value = super(raw_resource)
    value.nil? ? nil : value.to_s.split(',').map(&:strip)
  end

  on_apply do
    if cluster?
      if unknown_instances?
        Puppet.warning "#{path}: Skipping unknown instances #{unknown_instances.join(',')}" unless @warned
        @warned = true
      else
        provider.send("set_#{self.class.name}", known_instances)
      end
    else
      Puppet.warning "#{path}: #{name} has no effect on non clustered service."
    end
  end

  private

  def unknown_instances?
    unknown_instances.any?
  end

  def unknown_instances
    value - cluster_instances
  end

  def known_instances
    value & cluster_instances
  end


end
