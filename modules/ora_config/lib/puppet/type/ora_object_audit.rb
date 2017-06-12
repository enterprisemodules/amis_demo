require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/audit_property'
require 'puppet_x/enterprisemodules/oracle/mungers'
require 'puppet_x/enterprisemodules/oracle/default_sid'


Puppet::Type.newtype(:ora_object_audit) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This type allows you to enable or disable auditing inside an Oracle Database.

    Here is an example to set auditing on the `SYS.AUD$` table:

        ora_object_audit { 'SYS.AUD$@test':
          ensure            => 'present',
          alter_failure     => 'by_access',
          alter_success     => 'by_access',
          audit_failure     => 'by_access',
          audit_success     => 'by_access',
          comment_failure   => 'by_access',
          comment_success   => 'by_access',
          flashback_failure => 'by_access',
          flashback_success => 'by_access',
          grant_failure     => 'by_access',
          grant_success     => 'by_access',
          index_failure     => 'by_access',
          index_success     => 'by_access',
          insert_failure    => 'by_access',
          insert_success    => 'by_access',
          lock_failure      => 'by_access',
          lock_success      => 'by_access',
          rename_failure    => 'by_access',
          rename_success    => 'by_access',
          select_failure    => 'by_access',
          select_success    => 'by_access',
          update_failure    => 'by_access',
          update_success    => 'by_access',
        }

    Some audit options only apply to some types of database records. Specify only
    those options that apply to the object you want to audit.

  EOD

  ensurable

  to_get_raw_resources do
    sql_on_all_database_sids 'select * from dba_obj_audit_opts'
  end

  on_create do
    nil # Let the properties do their stuff
  end

  on_modify do
    nil # Let the properties do their stuff
  end

  on_destroy do
    [:sql, "noaudit all on #{owner}.#{object_name}", {:sid => sid}]
  end

  map_title_to_sid(:owner, :object_name) { /(.+)\.(.+)/ }

  parameter :name
  parameter :owner
  parameter :sid
  parameter :object_name

  property :alter_success
  property :alter_failure
  property :audit_success
  property :audit_failure
  property :comment_success
  property :comment_failure
  property :delete_success
  property :delete_failure
  property :grant_success
  property :grant_failure
  property :index_success
  property :index_failure
  property :insert_success
  property :insert_failure
  property :lock_success
  property :lock_failure
  property :rename_success
  property :rename_failure
  property :select_success
  property :select_failure
  property :update_success
  property :update_failure
  property :execute_success
  property :execute_failure
  property :create_success
  property :create_failure
  property :read_success
  property :read_failure
  property :write_success
  property :write_failure
  property :flashback_success
  property :flashback_failure
end
