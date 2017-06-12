require 'puppet_x/enterprisemodules/oracle/access'
require 'easy_type'

Puppet::Type.type(:ora_feature_usage).provide(:simple) do
  include EasyType::Provider
  include Puppet_X::EnterpriseModules::Oracle::Access

  confine :exists => '/etc/ora_setting.yaml'

  desc 'Report on database feature usage'

  mk_resource_methods
end
