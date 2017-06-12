# encoding: UTF-8
newparam(:logfile) do
  include EasyType

  desc <<-EOD
    The file to be used as redo log file.
  EOD

  on_apply do
    "LOGFILE #{value}"
  end
end
