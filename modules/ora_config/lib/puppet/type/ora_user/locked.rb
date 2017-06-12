newproperty(:locked) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::CreateOnly

  desc <<-EOD
    specified if the account is locked.

  EOD

  newvalues(true, false)

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('ACCOUNT_STATUS').include?('LOCKED') ? :true : :false
  end

  on_modify do
    "account #{state} "
  end

  after_create do
    sql("alter user #{resource.username} account #{state} ", :sid => resource.sid)
  end

  def state
    value == :true ? 'LOCK' : 'UNLOCK'
  end
end
