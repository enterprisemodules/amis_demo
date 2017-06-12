newproperty(:granted, :array_matching => :all) do
  include EasyType
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::GrantProperty
  include Puppet_X::EnterpriseModules::Oracle::Access

  to_translate_to_resource do |_raw_resource|
    #
    # We don't need a value, but we do need the side effects of the super method.
    #
    @all_rights ||= privileges + granted_roles
    nil
  end

  validate do |value|
    fail 'property grants and property granted are mutualy exclusive. You can only use one of them.' if resource.grants && resource.grants.any?
    fail 'You need to specify an Array instead of a comma separated string' if value =~ /,/
  end

  desc <<-EOD
    The grants you want to make sure are granted to the `ora_user` or `ora_role`. It is different from the
    `grants` property in the sense that this is not a full list of the rights, but just the rights
    that are granted to the user

    Here is an example with an `ora_user`:

        ora_user {'scott':
          ...
          granted => ['GRANT ANY ROLE'],
          ...
        }

    Here is an example with an `ora_role`:

        ora_role {'app_dba_role':
          ...
          granted => ['GRANT ANY ROLE'],
          ...
        }


    This property is mutual exclusive with the `grants` property.

  EOD

  #
  # This property manages grants without admin options
  #
  def self.admin
    false
  end


  def insync?(_is)
    should.any? { |r| current_rights.include?(r) }
  end

  def granted_rights
    value - current_rights
  end
end
