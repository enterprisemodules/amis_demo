newparam(:name) do
  include EasyType

  desc <<-EOD
  The name of the setting. This must be equal to the `sid` of the database.

  EOD

  isnamevar

  to_translate_to_resource do | raw_resource|
     raw_resource[self.name]
   end

end
