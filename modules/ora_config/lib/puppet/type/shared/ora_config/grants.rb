newproperty(:grants, :array_matching => :all) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::GrantProperty
  include Puppet_X::EnterpriseModules::Oracle::CreateOnly
  include EasyType::Mungers::Upcase

  desc <<-EOD
    grants for this user or role.

    All the grants this resource has. Here is an example on how to use this on an `ora_user`:

      ora_user { 'my_user@sid':
        ...
        grants => ['UNLIMITED TABLESPACE', 'CREATE PUBLIC SYNONYM'].
        ...
      }

    Here is an example on how to use this on an `ora_role`:

      ora_ora_role { 'my_role@sid':
        ...
        grants => ['UNLIMITED TABLESPACE', 'CREATE PUBLIC SYNONYM'].
        ...
      }

  EOD

  #
  # This property manages grants without admin options
  #
  def self.admin
    false
  end

  validate do |value|
    fail "#{value} is an invalid right. Use ora_object_permissions to set permissions on objects" if value.include?('.')
    fail "#{value} is an invalid right. Use ora_object_permissions to set permissions on objects" if value.include?(' on ')
    true
  end

  #
  # because the order may differ, but they are still the same,
  # to decide if they are equal, first do a sort on is and should
  #
  def insync?(is)
    return true if revoked_property_used?
    return true if granted_property_used?
    is = [] if is == :absent || is.nil?
    is.sort == should.sort
  end

  def revoked_property_used?
    resource.revoked && resource.revoked.any?
  end

  def granted_property_used?
    resource.granted && resource.granted.any?
  end

  def revoked_rights
    current_rights - value
  end

  def granted_rights
    value - current_rights
  end
end
