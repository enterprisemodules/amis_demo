require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'

Puppet::Type.type(:ora_asm_diskgroup).provide(:simple) do
  include EasyType::Provider
  include Puppet_X::EnterpriseModules::Oracle::Access

  confine :exists => '/etc/ora_setting.yaml'

  desc 'Manage RAC ASM groups in an Oracle Database via regular SQL'

  mk_resource_methods
end
