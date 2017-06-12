newproperty(:password) do
  include EasyType
  include EasyType::EncryptedProperty
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::Password
  include Puppet_X::EnterpriseModules::Oracle::CreateOnly


  desc <<-EOD
    The user's password.
  EOD

  #
  # Needed for information
  #
  def sid
    resource.sid
  end

  on_modify do
    "identified by \"#{value}\""
  end

  def insync?(_is)
    create_only_insync?(is_password_hash, should_password_hash)
  end

end
