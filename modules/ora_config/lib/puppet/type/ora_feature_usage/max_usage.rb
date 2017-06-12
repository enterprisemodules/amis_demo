newproperty(:max_usage) do
  include EasyType

  desc <<-EOD

      This resource allows you to specify the maximum usage for a certain Oracle feature

          ora_feature_usage { 'advanced_compression@dbname':
            ...
            max_usage => 200,
            ...
          }

  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource['USAGE']
  end

  on_create do
    nil
  end

  on_modify do
    if resource.when_used =~ /warning|WARNING/
      Puppet.warning "Oracle database feature #{resource.name} used more than specified max_usage(#{value})"
    else
      raise Puppet::Error, "Oracle database feature #{resource.name} used more than specified max_usage(#{value})"
    end
  end

  def insync?(is)
    return false if is < value
    super
  end

end
