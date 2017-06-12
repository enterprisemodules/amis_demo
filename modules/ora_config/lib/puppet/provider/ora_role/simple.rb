require 'puppet_x/enterprisemodules/oracle/access'
require 'easy_type'

Puppet::Type.type(:ora_role).provide(:simple) do
  include EasyType::Provider
  include Puppet_X::EnterpriseModules::Oracle::Access

  confine :exists => '/etc/ora_setting.yaml'

  desc 'Manage an Oracle role in an Oracle Database via regular SQL'

  mk_resource_methods
end
