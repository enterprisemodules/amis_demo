newparam(:tmp_dir) do
  desc <<-EOT
    The tmp extract directory of the schema definition.
  EOT

  defaultto '/tmp/ora_schema_defs'
end
