newparam(:for_sid) do
  include EasyType

  desc <<-EOD
    The SID you want to set the parameter for.
  EOD

  isnamevar

  defaultto do
    resource.scope.to_s == 'SPFILE' ? '*' : nil
  end
end
