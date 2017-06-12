# TODO: Check values
newproperty(:max_size) do
  include EasyType
  include TablespaceType
  include Puppet_X::EnterpriseModules::Oracle::Access

  desc <<-EOD
    Maximum size for autoextending.
  EOD

  def munge(size)
    return size if size.is_a?(Numeric)
    case size
    when /^\d+(K|k)$/ then size.chop.to_i * 1024
    when /^\d+(M|m)$/ then size.chop.to_i * 1024 * 1024
    when /^\d+(G|g)$/ then size.chop.to_i * 1024 * 1024 * 1024
    when /^unlimited$/ then 'unlimited'
    when /^\d+$/ then size.to_i
    else
      fail('invalid size')
    end
  end

  # TODO: Check why it doesn't return the right values
  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('MAX_SIZE').to_f.to_i
  end

  on_modify do
    if resource[:autoextend] == :on
      sql("alter database #{tablespace_type} '#{resource.provider.datafile}' autoextend on maxsize #{value}", :sid => resource.sid)
    else
      Puppet.warning "#{path}: property max_size changed on ora_tablespace[#{resource[:name]}], but autoextend is off. Change has no effect. "
    end
    nil
  end

  on_create do
    if resource[:autoextend] == :on
      "maxsize #{value}"
    else
      Puppet.warning "#{path}: property max_size changed on ora_tablespace[#{resource[:name]}], but autoextend is off. Change has no effect. "
      nil
    end
  end
end
