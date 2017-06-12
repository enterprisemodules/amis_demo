require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_statement_audit) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This type allows you to enable or disable auditing inside an Oracle Database.

  EOD

  ensurable

  to_get_raw_resources do
    sql_on_all_database_sids 'select audit_option from dba_stmt_audit_opts where user_name is null and proxy_name is null'
  end

  on_create do
    [:sql, "audit #{audit_option}", {:sid => sid}]
  end

  on_modify do
    info 'Audit alteration not possible, command ignored'
    nil
  end

  on_destroy do
    [:sql, "noaudit #{audit_option}", {:sid => sid}]
  end

  map_title_to_sid(:audit_option)

  parameter :name
  parameter :audit_option
  parameter :sid

end
