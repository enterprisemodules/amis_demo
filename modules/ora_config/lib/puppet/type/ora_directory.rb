require 'pathname'
current_path = Pathname.new(__FILE__).dirname
$LOAD_PATH.unshift(current_path.parent.parent)
$LOAD_PATH.unshift(current_path.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_directory) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid
  #
  # Create a new type oracle_directory. Oracle directory, works in conjunction
  # with the Resource provider
  #
  desc <<-EOD

    This resource allows you to manage directory mappings from inside an Oracle database to
    a directory outside of the database. Here is an example:

        ora_directory { 'ORACLE_OCM_CONFIG_DIR2@test':
          ensure         => 'present',
          directory_path => '/opt/oracle/app/11.04/ccr/state',
        }

  EOD

  ensurable

  to_get_raw_resources do
    sql_on_all_database_sids 'select * from dba_directories'
  end

  on_create do
    [:sql, "create directory #{directory_name} as '#{directory_path}'", {:sid => sid}]
  end

  on_modify do
    [:sql, "create or replace directory #{directory_name} as '#{directory_path}'", {:sid => sid}]
  end

  on_destroy do
    [:sql, "drop directory #{directory_name}", {:sid => sid}]
  end

  map_title_to_sid(:directory_name)

  parameter :name
  parameter :sid
  parameter :directory_name
  property  :directory_path
end
