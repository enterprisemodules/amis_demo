newparam(:segment_space_management) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access

  desc <<-EOD
    TODO: Give description.
  EOD

  newvalues(:auto, :manual)

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('SEGMEN').downcase.to_sym
  end

  after_modify do
    sql("alter tablespace #{resource[:name]} segment space management #{value}", :sid => sid)
  end
end
