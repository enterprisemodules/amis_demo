require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_package) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
  This resource allows you to manage PL/SQL packages in the Oracle database.

      ora_package { 'testuser.pkg_manage_my_objects':
        ensure  => 'present',
        source => '/vagrant/tests/package.sql',
      }

  This puppet definition ensures that the package `testuser.pkg_manage_my_objects` is available
  in the database and that its content matches the content defined in the specfied source.

  To decide if the package needs an update, the puppet type compares the content in the database, with
  the content in the source file. This comparison is done insenitive to case, white spacing and used quote's
  (the " or the ` ).

  When you have specfied `report_errors => true` (which is the default), the type will fail on PL/SQL
  compilation errors. Packages with compilation errors do however end up in the database. On a second Puppet
  run the won't be updated. Puppet reports a warning these resources though?

  ```
  Warning: package TESTUSER.PKG_MANAGE_MY_OBJECTS@test up-to-date, but contains 4 error(s).
  ```

  EOD

  to_get_raw_resources do
    sql_on_all_database_sids "select distinct owner, name  from dba_source where type = 'PACKAGE'"
  end

  on_create do
    apply
  end

  on_modify do
    apply
  end

  on_destroy do
    [:sql, "drop package #{owner}.#{package_name}", {:sid => sid}]
  end

  def apply
    options = { :sid => sid, :parse => false, :catch_extra_errors => /compilation errors/ }
    options[:failonsqlfail] = report_errors
    statement = "@#{source}"

    if cwd
      fail "Working directory '#{cwd}' does not exist" unless File.directory?(cwd)
      FileUtils.cd(cwd)
    end
    output = sql statement, options
    Puppet.debug(output) if logoutput == :true
    nil
  end

  map_title_to_sid(:owner, :package_name) { /(.+)\.(.+)/ }

  ensurable

  parameter :name
  parameter :owner
  parameter :package_name
  parameter :sid
  parameter :timeout
  parameter :cwd
  parameter :logoutput
  parameter :editionable
  parameter :report_errors

  property  :source

  ora_autorequire(:ora_user, :owner)

end
