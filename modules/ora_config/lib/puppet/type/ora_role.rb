require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/create_only'
require 'puppet_x/enterprisemodules/oracle/grant_property'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_role) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This type allows you to create or delete a role inside an Oracle Database.

    It recognises a limit part of the options that [CREATE ROLE](http://docs.oracle.com/cd/B28359_01/server.111/b28286/statements_6012.htm#SQLRF01311) supports.

        ora_role {'just_a_role@sid':
          ensure    => present,
        }

    You can also add grants to a role:

        ora_role {'just_a_role@sid':
          ensure    => present,
          grants    => ['create session','create table'],
        }

  EOD

  ensurable

  to_get_raw_resources do
    sql_on_all_database_sids 'select * from dba_roles'
  end

  on_create do
    [:sql, "create role #{role_name}", {:sid => sid}]
  end

  on_modify do
    nil # Let the properties do their stuff
  end

  on_destroy do
    [:sql, "drop role #{role_name}", {:sid => sid}]
  end

  map_title_to_sid(:role_name)

  parameter :name
  parameter :role_name
  parameter :sid
  parameter :password
  property  :container
  property  :grants
  property  :revoked
  property  :granted
  property  :grants_with_admin
  property  :revoked_with_admin
  property  :granted_with_admin

  def grant_key
    role_name
  end

  #
  # This method is used to specify the Column table for fetching the granted roles
  #
  class << self
    attr_reader :grantee_column
  end
  @grantee_column = 'ROLE'
end
