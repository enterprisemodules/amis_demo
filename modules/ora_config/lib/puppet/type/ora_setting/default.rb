newproperty(:default, :boolean => true, :parent => Puppet::Property::Boolean) do
  include EasyType::YamlProperty

  desc <<-EOD
    When you set this value to true, this database will be used when no explcit `sid` is specified on the
    Oracle types.

    Many of the of the oracle types, allow you to NOT specfify the `sid` and use a default `sid`. This makes
    puppet manifests easier readable and less verbose when creating a manifest for a single database.

    The databasse for which you set the property `default` to `true`, is the database that will be used for those
    operations.

  EOD
  defaultto :false

  newvalues(:true, :false)

  on_apply do
    reset_defaults if value
    resource.class.configuration[resource[:name]]['default'] = value
    nil
  end

  def reset_defaults
    resource.class.configuration.each { |_k, v| v['default'] = false }
  end
end
