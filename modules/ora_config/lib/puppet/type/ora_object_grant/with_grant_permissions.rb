newproperty(:with_grant_permissions, :array_matching => :all) do
  include EasyType
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::Access

  desc <<-EOD
    The permissions on the specfied object, granted to the specfied user with the option to regrant to an other user.

    This is a required array of rights to grant on the user object combination

        ora_object_grant{ ...:
          with_grant_permissions => ['execute', 'select'],
        }

    When this list contains less rights then currently granted, the the extra rights will
    be revoked from the user. If the permissions list contains more rights then currently
    granted in the database, the extra rights will be granted to the user.

    If you want to make sure no rights are granted, you must use an empty array.

        ora_object_grant{ ...:
          with_grant_permissions => ['execute', 'select'],
        }

  EOD

  isrequired

  to_translate_to_resource do |raw_resource|
    permissions = raw_resource['GRANTED_PRIVS']
    case permissions
    when NilClass
      nil
    when String
      [permissions]
    when Array
      permissions
    else
      fail 'internal error. We should only get a string or an array here.'
    end
  end

  def insync?(is)
    is = [] if is == :absent || is.nil?
    is.sort == munged_should.sort
  end

  def change_to_s(_from, _to)
    return_value = []
    return_value << "revoked the #{revoked_rights.join(',')} right(s) with grant option" unless revoked_rights.empty?
    return_value << "granted the #{granted_rights.join(',')} right(s) with grant option" unless granted_rights.empty?
    return_value.join(' and ')
  end

  on_apply do
    revoked_rights.each do |right|
      sql(revoke(right), :sid => sid)
    end
    granted_rights.each do |right|
      sql(grant(right), :sid => sid)
    end
    nil
  end

  private

  def munged_should
    (should == :absent || should.nil?) ? [] : should
  end

  def current_rights
    # TODO: Check why this needs to be so difficult
    resource.to_resource.to_hash.delete_if { |_key, value| value == :absent }.fetch(:with_grant_permissions) { [] }
  end

  def expected_rights
    resource.to_hash.fetch(:with_grant_permissions) { [] }
  end

  def revoked_rights
    current_rights - expected_rights
  end

  def granted_rights
    expected_rights - current_rights
  end

  def revoke(right)
    "revoke #{right} on #{resource.object_name} from #{resource.grantee}"
  end

  def grant(rights)
    "grant #{rights} on #{resource.object_name} to #{resource.grantee} with grant option"
  end
end
