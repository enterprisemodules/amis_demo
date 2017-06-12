# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassAndModuleChildren

require 'pathname'
current_path = Pathname.new(__FILE__).dirname
$LOAD_PATH.unshift(current_path.parent.parent)
$LOAD_PATH.unshift(current_path.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/information'
require "#{current_path}/ora_profile/profile_property"
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_profile) do
  #
  # Create a new type oracle_profile. Oracle profile, works in conjunction
  # with the Resource provider
  #

  # Doc
  class ::Puppet::Type::Ora_profile
    include EasyType
    include Puppet_X::EnterpriseModules::Oracle::Access
    include Puppet_X::EnterpriseModules::Oracle::Information
    extend Puppet_X::EnterpriseModules::Oracle::TitleParser
    include Puppet_X::EnterpriseModules::Oracle::DefaultSid

    desc <<-EOD
      This resource allows you to manage a user profile in an Oracle database.

      Here is an example on how to use this:

          ora_profile { 'DEFAULT@sid':
            ensure                    => 'present',
            composite_limit           => 'UNLIMITED',
            connect_time              => 'UNLIMITED',
            cpu_per_call              => 'UNLIMITED',
            cpu_per_session           => 'UNLIMITED',
            failed_login_attempts     => '10',
            idle_time                 => 'UNLIMITED',
            logical_reads_per_call    => 'UNLIMITED',
            logical_reads_per_session => 'UNLIMITED',
            password_grace_time       => '7',
            password_life_time        => '180',
            password_lock_time        => '1',
            password_reuse_max        => 'UNLIMITED',
            password_reuse_time       => 'UNLIMITED',
            password_verify_function  => 'NULL',
            private_sga               => 'UNLIMITED',
            sessions_per_user         => 'UNLIMITED',
            container                 => 'ALL'
          }

    EOD

    ensurable

    to_get_raw_resources do
      statement = for_version(
        :'12'     => 'select distinct profile, common from dba_profiles',
        :default  => 'select distinct profile from dba_profiles'
      )
      sql_on_all_database_sids(statement)
    end

    on_create do
      [:sql, "create profile #{profile_name} limit", { :sid => sid, :append => scope }]
    end

    on_modify do
      [:sql, "alter profile #{profile_name} limit", { :sid => sid, :append => scope }]
    end

    on_destroy do
      [:sql, "drop profile #{profile_name} cascade", { :sid => sid }]
    end

    def scope
      provider.container == :all ? 'container = all' : ''
    end

    map_title_to_sid(:profile_name)

    parameter :name
    parameter :profile_name
    parameter :sid

    property  :cpu_per_session
    property  :cpu_per_call
    property  :connect_time
    property  :idle_time
    property  :logical_reads_per_session
    property  :logical_reads_per_call
    property  :composite_limit
    property  :private_sga
    property  :failed_login_attempts
    property  :password_life_time
    property  :password_reuse_time
    property  :password_reuse_max
    property  :password_lock_time
    property  :password_grace_time
    property  :password_verify_function
    property  :sessions_per_user
    property  :container
  end
end
