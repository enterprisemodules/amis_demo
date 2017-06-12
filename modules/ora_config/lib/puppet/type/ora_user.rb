# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassAndModuleChildren

require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'easy_type/array_property'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/password'
require 'puppet_x/enterprisemodules/oracle/create_only'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/grant_property'
require 'puppet_x/enterprisemodules/oracle/utilities'
require 'puppet_x/enterprisemodules/oracle/default_sid'

#
# Create a new type oracle_user. Oracle user, works in conjunction
# with the Resource provider
#
Puppet::Type.newtype(:ora_user) do
  # docs
  class ::Puppet::Type::Ora_user
    include EasyType
    include Puppet_X::EnterpriseModules::Oracle::Access
    extend Puppet_X::EnterpriseModules::Oracle::TitleParser
    include Puppet_X::EnterpriseModules::Oracle::DefaultSid

    desc <<-EOD
      This type allows you to manage a user inside an Oracle database.

      It recognises most of the options that [CREATE USER](http://docs.oracle.com/cd/B28359_01/server.111/b28286/statements_8003.htm#SQLRF01503) supports. Besides these options, you can also use this type to manage the grants and the quota's for this user.

          ora_user{user_name@sid:
            temporary_tablespace      => temp,
            default_tablespace        => 'my_app_ts',
            password                  => 'verysecret',
            require                   => Ora_tablespace['my_app_ts'],
            grants                    => ['SELECT ANY TABLE', 'CONNECT', 'CREATE TABLE', 'CREATE TRIGGER'],
            quotas                    => {
                                            "my_app_ts"  => 'unlimited'
                                          },
          }
    EOD

    ensurable

    to_get_raw_resources do
      sql_on_all_database_sids 'select * from dba_users'
    end

    on_create do
      self[:password] ||= SecureRandom.hex(8)
      [:sql, "create user #{username} identified by \"#{password}\"", { :skip_without_properties => true, :sid => sid }]
    end

    on_modify do
      [:sql, "alter user #{username}", { :skip_without_properties => true, :sid => sid, :append => scope }]
    end

    on_destroy do
      [:sql, "drop user #{username} cascade", { :sid => sid }]
    end

    def scope
      provider.container == :all ? 'container = all' : ''
    end

    map_title_to_sid(:username)

    parameter :name
    parameter :username
    parameter :sid
    parameter :create_only

    property  :default_tablespace
    property  :expired
    property  :grants
    property  :revoked
    property  :granted
    property  :grants_with_admin
    property  :revoked_with_admin
    property  :granted_with_admin
    property  :default_roles # This one needs to be after grants
    property  :locked
    property  :password
    property  :profile
    property  :quotas
    property  :temporary_tablespace
    property  :container


    ora_autorequire(:ora_tablespace, [:default_tablespace, :temporary_tablespace, Proc.new { quotas ? quotas.keys : nil} ])
    ora_autorequire(:ora_profile, :profile)
    ora_autorequire(:ora_role, :default_roles)

    def grant_key
      username
    end

    #
    # This method is used to specify the Column table for fetching the granted roles
    #
    class << self
      attr_reader :grantee_column
    end
    @grantee_column = 'USERNAME'
  end
end
