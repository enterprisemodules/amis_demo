newproperty(:autoextend) do
  include EasyType
  include TablespaceType
  include Puppet_X::EnterpriseModules::Oracle::Access

  desc <<-EOD
    Enable autoextension for the tablespace.
  EOD

  newvalues(:on, :off)
  aliasvalue(:yes, :on)
  aliasvalue(:no, :off)
  aliasvalue(true, :on)
  aliasvalue(false, :off)

  to_translate_to_resource do |raw_resource|
    case raw_resource.column_data('AUT')
    when 'YES' then :on
    when 'NO' then :off
    else
      fail('Invalid autoxtend found in tablespace resource.')
    end
  end

  on_modify do
    sql("alter database #{tablespace_type} '#{resource.provider.datafile}' autoextend #{value}", :sid => resource.sid)
    nil
  end

  on_create do
    "autoextend #{resource[:autoextend]}"
  end
end
