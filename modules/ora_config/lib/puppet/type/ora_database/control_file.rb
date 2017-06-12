# encoding: UTF-8
newparam(:control_file) do
  include EasyType

  desc <<-EOD
    Specify reuse, to reuse existing control files.
  EOD

  newvalues(:reuse)

  on_apply do
    "CONTROLFILE #{value}"
  end
end
