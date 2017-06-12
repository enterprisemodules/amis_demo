newproperty(:cdb, :boolean => true, :parent => Puppet::Property::Boolean) do
  include EasyType::YamlProperty

  desc <<-EOD
    Is the database we manage a container database? If so set this value to true.
    When you set this property to `true`, you enable container_database behaviour for this database. Here is
    an example on how to use this.
        ora_setting {container_database
          ...
          cdb => true
          ...
        }
  EOD
  defaultto :false
  newvalues(:true, :false)
end
