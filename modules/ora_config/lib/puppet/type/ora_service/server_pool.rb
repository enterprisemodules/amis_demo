newproperty(:server_pool, :array_matching => :all) do
  include Puppet_X::EnterpriseModules::Oracle::ServiceProperty
  include EasyType::ArrayProperty

  desc <<-EOD
    The name of a server pool used when the database is policy managed.

    Here is an example on how to use this:

        ora_service{'my_service':
          ...
          server_pool => ['pool1', 'pool2'],
          ...
        }

    This is a cluster only property. On single node database this property will be ignored. If you use it,
    Puppet will issue a warning.

  EOD

  column_name 'Server pool'

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

end
