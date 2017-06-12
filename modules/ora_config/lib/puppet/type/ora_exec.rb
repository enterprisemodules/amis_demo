require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_exec) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This type allows you run a specific SQL statement or an sql file on a specified instance sid.

        ora_exec{"drop table application_users@sid":
          username => 'app_user',
          password => 'password,'
        }

    This statement will execute the sql statement `drop table application_users` on the instance names `instance`.

    You can use the `unless` parameter to only execute the statement in certain states. If the query specified in the
    `unless` parameter returns one or more records, the main statement is skipped.

        ora_exec{ "create synonym ${user}.${synonym} for USER.${synonym}":
          unless  => "select * from all_synonyms where owner=\'${user}\' and synonym_name=\'${synonym}\'",
        }

    You can also execute a script.

        ora_exec{"@/tmp/do_some_stuff.sql@sid":
          username  => 'app_user',
          password  => 'password,'
          logoutput => on_failure,  # can be true, false or on_failure
        }

    This statement will run the sqlscript `/tmp/do_some_stuff.sql` on the sid named `sid`. Use the `unless`
    parameter to just execute the script in certain situations.

    When you don't specify the username and the password, the type will connect as `sysdba`.


  EOD

  map_titles_to_attributes([
    /^((@.*)@(.*))$/, [:name, :statement, :sid],
    /^((.*)@(.*))$/,  [:name, :statement, :sid],
    /^((@.*))$/,      [:name, :statement],
    /^((.*))$/,       [:name, :statement],
  ])

  map_title_to_sid(:statement)

  def refresh
    provider.execute if self[:unless].nil? || (self[:unless] && provider.unless_value?)
  end

  parameter :name
  property  :statement
  parameter :sid

  parameter :timeout
  parameter :cwd
  parameter :logoutput
  parameter :password
  parameter :username
  parameter :unless
  parameter :refreshonly
  parameter :report_errors
  parameter :mark_as_error

  ora_autorequire(:ora_user, :username)

end
