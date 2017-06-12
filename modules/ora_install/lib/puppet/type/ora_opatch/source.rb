require 'easy_type/source_dir'

newparam(:source, :parent => EasyType::SourceDir) do
  # desc <<-EOT
  #   The source of the patch. Can be either an extracted folder or the raw zip file.
  #
  #   The source of the file can also be a puppet url. In that case, the files is fetched from
  #   the Puppet server and used as the source for the opatch command.
  #
  # EOT

  defaultto ''

  isrequired
end
