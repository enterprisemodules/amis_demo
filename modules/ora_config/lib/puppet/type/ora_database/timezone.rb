# encoding: UTF-8
newparam(:timezone) do
  include EasyType

  desc <<-EOD
    Set the time zone of the database.
  EOD
end
