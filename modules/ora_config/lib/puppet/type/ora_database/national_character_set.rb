# encoding: UTF-8
newparam(:national_character_set) do
  include EasyType

  desc <<-EOD
    The national character set used to store data in columns.
  EOD

  on_apply do
    "NATIONAL CHARACTER SET #{value}"
  end
end
