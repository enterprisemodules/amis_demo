# encoding: UTF-8
newparam(:maxdatafiles) do
  include EasyType
  include EasyType::Validators::Integer

  desc <<-EOD
    The initial sizing of the datafiles section of the control file.
  EOD

  on_apply do
    "MAXDATAFILES #{value}"
  end
end
