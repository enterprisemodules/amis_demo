# encoding: UTF-8
newparam(:character_set) do
  include EasyType

  desc <<-EOD
    Specify the character set the database uses to store data.
  EOD

  on_apply do
    "character set #{value}"
  end
end
