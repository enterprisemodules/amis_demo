newparam(:recurse, :boolean => true, :parent => Puppet::Parameter::Boolean) do

  desc <<-EOD
    When you set this value to true, this ASM directory and all parent directories will be
    automatically created.

  EOD

  defaultto :false

  newvalues(:true, :false)
end
