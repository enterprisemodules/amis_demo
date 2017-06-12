require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/default_sid'

#
# Create a new type oracle_user. Oracle user, works in conjunction
# with the SqlResource
#
Puppet::Type.newtype(:ora_thread) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This resource allows you to manage threads in an Oracle database.


    This type allows you to enable a thread. Threads are used in Oracle RAC installations. This type is not very useful
    for regular use, but it is used in the [Oracle RAC module](https://forge.puppetlabs.com/hajee/ora_rac).


        ora_thread{"2@sid":
          ensure  => 'enabled',
        }

    This enables thread 2 on instance named `sid`

  EOD

  to_get_raw_resources do
    sql_on_all_database_sids 'select thread#, enabled from v$thread'
  end

  on_create do
    [:sql, "alter database enable thread #{thread_number}", {:sid => sid}]
  end

  on_modify do
    [:sql, "alter database #{new_state} thread #{thread_number}", {:sid => sid}]
  end

  on_destroy do
    fail 'You can not delete a thread like this. Stop the database and remove it from the spfile'
  end

  parameter :name
  parameter :thread_number
  parameter :sid

  property  :ensure

  map_title_to_sid(:thread_number)

  def new_state
    self[:ensure].to_s.chop
  end
end
