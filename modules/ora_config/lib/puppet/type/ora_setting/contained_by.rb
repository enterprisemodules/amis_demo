newproperty(:contained_by) do
  include EasyType::YamlProperty

  desc <<-EOD
  The container database where this pluggable belings to.

  Here is an example:

      ora_setting { 'DB1':
        ...
        contained_by     => "CDB",
        ...
      }

  EOD

  defaultto ''
end
