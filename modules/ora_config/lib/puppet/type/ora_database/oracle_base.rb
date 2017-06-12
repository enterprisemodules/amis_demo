# encoding: UTF-8
newparam(:oracle_base) do
  include EasyType

  defaultto '/opt/oracle'

  desc <<-EOD
    The oracle_base directory.
  EOD
end
