newproperty(:logging) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access

  desc <<-EOD
    TODO: Add description.
  EOD

  newvalues(:yes, :no)

  to_translate_to_resource do |raw_resource|
    case raw_resource.column_data('LOGGING')
    when 'LOGGING' then :yes
    when 'NOLOGGING' then :no
    else
      fail('Invalid Logging found in tablespace resource.')
    end
  end

  after_modify do
    logging = resource[:logging] == :yes ? 'logging' : 'nologging'
    sql("alter tablespace #{resource[:tablespace_name]} #{logging}", :sid => resource.sid)
  end

  on_create do
    if resource[:logging] == :yes
      'logging'
    else
      'nologging'
    end
  end
end
