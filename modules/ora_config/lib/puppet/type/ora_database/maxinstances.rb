# encoding: UTF-8
newparam(:maxinstances) do
  include EasyType
  include EasyType::Validators::Integer

  desc <<-EOD
    The maximum number of instances that can simultaneously have this database mounted and open.
  EOD

  on_apply do
    "MAXINSTANCES #{value}"
  end
end
