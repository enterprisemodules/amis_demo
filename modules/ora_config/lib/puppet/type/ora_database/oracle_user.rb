# encoding: UTF-8
newparam(:oracle_user) do
  include EasyType

  defaultto 'oracle'

  desc <<-EOD
    The oracle user.
  EOD
end
