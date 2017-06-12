newparam(:password) do
  include EasyType

  desc <<-EOD
    The password to use when connecting to to the database.
  EOD

  to_translate_to_resource do |_raw_resource|
    ''
  end

  on_apply do
    "identified by #{value}"
  end
end
