newproperty(:preferred_instances, :array_matching => :all) do
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty
  include EasyType::ArrayProperty

  desc <<-EOD
    A list of preferred instances on which the service runs when the database is administrator managed.

    Here is an example on how to use this:

        ora_service{'my_service':
          ...
          prefered_instances => ['SID1', 'SID2'],
          ...
        }

    When an instance is specfied that does not or not yes exist in the cluster, Puppet will
    ignore it.

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'Preferred instances'


  def insync?(is)
    is = [] if is == :absent
    if cluster?
      is.sort == should.sort
    else
      Puppet.warning "#{path}: #{name} has no effect on non clustered service."
    end
  end

  to_translate_to_resource do |raw_resource|
    value = super(raw_resource)
    value.nil? ? nil : value.to_s.split(',').map(&:strip)
  end

  on_create do
    if cluster?
      #
      # If it contains unknown instances at this point in time, filter them out
      #
      if unknown_instances?
        Puppet.warning "#{resource}: Skipping unknown instances #{unknown_instances.join(',')}" unless @warned
        @warned = true
      else
        provider.send("create_#{self.class.name}", known_instances)
      end
    else
      Puppet.warning "#{resource}: preferred_instances has no effect on non clustered service."
    end
  end

  on_modify do
    provider.update_preferred_instances(known_instances)
  end

  private

  #
  # If the value is empty, use all current instances as default
  #
  def requested_value
    value.empty? ? cluster_instances : value
  end

  def unknown_instances?
    unknown_instances.any?
  end

  def unknown_instances
    requested_value - cluster_instances
  end

  def known_instances
    requested_value & cluster_instances
  end
end
