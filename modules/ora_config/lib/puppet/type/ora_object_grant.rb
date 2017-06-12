require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_object_grant) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid


  desc <<-EOD
    This type allows you to grant users rights to specified database objects.

    To grant user `SCOTT` `execute` and `debug` rights on on the `sys.dbms_aqin` packgage, you can use:

        ora_object_grant{'SCOTT->sys.dbms_aqin@SID':
          permissions => ['execute', 'debug'],
        }

    If you want to make sure the user only has `execute` rights, use:

        ora_object_grant{'OTHER_USER->sys.dbms_aqin@SID':
           permissions => ['execute'],
        }

    If you want to make sure **no** permissions are granted, you can use an empty array like this:

        ora_object_grant{'OTHER_USER->sys.dbms_aqin':
           permissions => [],
        }
  EOD

  to_get_raw_resources do
    provider(:prefetching).all_resources
  end

  on_create do
    nil # Let the permissions property do its work
  end

  on_modify do
    nil # Let the permissions property do its work
  end

  on_destroy do
    fail "we shouldn't be in on_destroy in ora_object_grant"
  end

  map_title_to_sid(:grantee, :object_name) { /(.+)->(.+)/ }

  parameter :name
  parameter :object_name
  parameter :grantee
  parameter :sid
  property  :permissions
  property  :with_grant_permissions
  property  :container

  #
  # Because grantee can be either a user or a role, make autorequires on both.
  # It doesn't matter if an autorequire is created to a non existing object.
  #
  ora_autorequire(:ora_user, [:grantee, :object_owner])
  ora_autorequire(:ora_role, :grantee)

  def object_owner
    elements = object_name.split('.')
    elements.first if elements.size > 1 # Object name contains a dot
    ''
  end
end
