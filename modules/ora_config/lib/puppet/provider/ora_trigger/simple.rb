# encoding: UTF-8
require 'puppet_x/enterprisemodules/oracle/access'
require 'easy_type'

Puppet::Type.type(:ora_trigger).provide(:simple) do
  include EasyType::Provider
  include Puppet_X::EnterpriseModules::Oracle::Access

  confine :exists => '/etc/ora_setting.yaml'
  #
  # No need to add or remove anything here
  #
  desc 'This is the generic provider for a easy_type type'

  mk_resource_methods
end
