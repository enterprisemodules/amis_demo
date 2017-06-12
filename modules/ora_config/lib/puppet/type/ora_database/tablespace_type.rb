# encoding: UTF-8
newparam(:tablespace_type) do
  include EasyType

  newvalues(:bigfile, :smallfile)

  desc <<-EOD
    Use this set the default type created tablespaces including SYSTEM and SYSAUX tablespaces.
  EOD

  on_apply do
    "SET DEFAULT #{value} TABLESPACE"
  end
end
