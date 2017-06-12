Puppet::Type.type(:ora_setting).provide(:simple) do
  include EasyType::Provider

  desc 'Manage ora settings through yaml file'
  mk_resource_methods

end
