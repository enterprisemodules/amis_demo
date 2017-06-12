# encoding: UTF-8
newparam(:maxloghistory) do
  include EasyType
  include EasyType::Validators::Integer

  desc <<-EOD
    define the limits for the redo log.
  EOD

  on_apply do
    "MAXLOGHISTORY #{value}"
  end
end
