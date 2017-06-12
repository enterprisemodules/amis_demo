# encoding: UTF-8
newparam(:sys_password) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Utilities

  defaultto generated_password(12)

  desc <<-EOD
    The password of the SYS account.
    This parameter is mandatory when creating a (container) database.
  EOD

  on_apply do
    "user sys identified by #{value}"
  end
end
