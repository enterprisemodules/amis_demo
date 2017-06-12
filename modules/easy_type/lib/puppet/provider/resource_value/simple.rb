require 'easy_type'

Puppet::Type.type(:resource_value).provide(:simple) do
  include EasyType::Provider

  desc 'Manage individual properties as a full resource'

  mk_resource_methods
end
