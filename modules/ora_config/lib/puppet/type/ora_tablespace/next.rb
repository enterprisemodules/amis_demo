newproperty(:next) do
  include EasyType
  include TablespaceType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include EasyType::Mungers::Size

  desc <<-EOD
    Size of the next autoextent.
  EOD

  to_translate_to_resource do |raw_resource|
    block_size = raw_resource.column_data('BLOCK_SIZE').to_i
    increment = raw_resource.column_data('INCREMENT_BY').to_i
    increment * block_size
  end

  on_create do
    if resource[:autoextend] == :on
      "next #{value}"
    else
      Puppet.warning "#{path}: property next changed on ora_tablespace[#{resource[:name]}], but autoextend is off. "
      nil
    end
  end

  on_modify do
    if resource[:autoextend] == :on
      sql("alter database #{tablespace_type} '#{resource.provider.datafile}' autoextend on next #{value}", :sid => resource.sid)
    else
      Puppet.warning "#{path}: property next changed on ora_tablespace[#{resource[:name]}], but autoextend is off. "
      nil
    end
  end

end
