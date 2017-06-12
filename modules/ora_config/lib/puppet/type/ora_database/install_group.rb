# encoding: UTF-8
newparam(:install_group) do
  include EasyType

  defaultto 'oinstall'

  desc <<-EOD
    The oracle_install group.
  EOD
end
