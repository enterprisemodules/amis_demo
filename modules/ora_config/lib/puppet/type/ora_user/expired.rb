newproperty(:expired) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::Password
  include Puppet_X::EnterpriseModules::Oracle::CreateOnly

  desc <<-EOD
    specified if the account is expired.
  EOD

  newvalues(:true, :false)

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('ACCOUNT_STATUS').include?('EXPIRED') ? :true : :false
  end

  on_create do
    'password expire' if value == :true
  end

  on_modify do
    if value == :true
      'password expire'
    else
      # TODO: Do we want to use this method (in this way)
      if provider.send(:modified?, resource.parameters.fetch(:password))
        ''
      else
        "identified by values '#{current_hashed_password}'"
      end
    end
  end
end
