# encoding: UTF-8
newparam(:system_password) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Utilities

  defaultto generated_password(12)

  desc <<-EOD
    The password of the SYSTEM account.
    This parameter is mandatory when creating a (container) database.
  EOD

  on_apply do
    "user system identified by #{value}"
  end
end
