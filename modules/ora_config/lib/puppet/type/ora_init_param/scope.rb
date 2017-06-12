newparam(:scope) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The scope of the change.
  EOD

  newvalues(:SPFILE, :MEMORY, :spfile, :memory)

end
