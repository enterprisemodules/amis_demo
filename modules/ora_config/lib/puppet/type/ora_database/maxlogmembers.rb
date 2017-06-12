# encoding: UTF-8
newparam(:maxlogmembers) do
  include EasyType
  include EasyType::Validators::Integer

  desc <<-EOD
    The maximum number of members, or copies, for a redo log file group.
  EOD

  on_apply do
    "MAXLOGMEMBERS #{value}"
  end
end
