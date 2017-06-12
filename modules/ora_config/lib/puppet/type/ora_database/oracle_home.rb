# encoding: UTF-8
newparam(:oracle_home) do
  include EasyType

  desc <<-EOD
    The oracle_home directory.
  EOD
end

def oracle_home
  self[:oracle_home] ? self[:oracle_home] : "#{self[:oracle_base]}/app/#{name}"
end
