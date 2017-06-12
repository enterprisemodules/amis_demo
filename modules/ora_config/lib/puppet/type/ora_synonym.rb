require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/default_sid'

#
# Create a new type oracle_synonym. Oracle synonym, works in conjunction
# with the Resource provider
#
Puppet::Type.newtype(:ora_synonym) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This resource allows you to manage a synonym an Oracle database. You can create both
    public synonyms or private synonyms. To create a public synonym use:

        ora_synonym { 'PUBLIC.SYNONYM_NAME@SID':
          ensure      => 'present',
          table_name  => 'TABLE_NAME',
          table_owner => 'TABLE_OWNER',
        }

    To create a private synonym, you'll have to specfy the owner in the title:

        ora_synonym { 'OWNER.SYNONYM_NAME@SID':
          ensure      => 'present',
          table_name  => 'TABLE_NAME',
          table_owner => 'TABLE_OWNER',
        }

  EOD

  ensurable

  to_get_raw_resources do
    sql_on_all_database_sids 'select * from dba_synonyms'
  end

  on_create do
    apply
  end

  on_modify do
    apply
  end

  def apply
    statement = if owner == 'PUBLIC'
                  "create or replace public synonym #{synonym_name} for #{table_owner}.#{table_name}"
                else
                  "create or replace synonym #{owner}.#{synonym_name} for #{table_owner}.#{table_name}"
                end
    [:sql, statement, {:sid => sid}]
  end

  on_destroy do
    statement = if owner == 'PUBLIC'
                  "drop public synonym #{synonym_name}"
                else
                  "drop synonym #{owner}.#{synonym_name}"
                end
    [:sql, statement, {:sid => sid}]
  end

  map_title_to_sid(:owner, :synonym_name) { /(.+)\.(.+)/ }

  parameter :name
  parameter :sid
  parameter :synonym_name
  parameter :owner
  property :table_owner
  property :table_name

  ora_autorequire(:ora_user, [:owner, :table_owner])
end
