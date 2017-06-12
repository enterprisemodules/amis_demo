require 'puppet_x/enterprisemodules/oracle/access'
require 'easy_type'

Puppet::Type.type(:ora_database).provide(:simple) do
  include EasyType::Provider

  confine :feature => :oratab_exists

  desc 'Manage an Oracle Database'

  mk_resource_methods
end
