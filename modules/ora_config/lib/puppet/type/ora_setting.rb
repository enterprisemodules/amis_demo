require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet/property/boolean'

module Puppet
  Type.newtype(:ora_setting) do
    include EasyType::YamlType

    config_file '/etc/ora_setting.yaml'

    desc <<-EOD
    This resource allows you to set the defaults for all other ora types.


    All ora types need a `ora_setting` definition. This is a pointer to a local or remote database.
    You need to create one for every local, remote or pluggable database you want to manage.
    When you don't provide a `ora_setting` identifier in the title of the oracle type then it will use `default` as identifier.
    The connect string is according to the EZCONNECT naming method.

    Here is an example on how to create the `default` settings:

        ora_setting { '<SID>':
          default        => true|false,
          user           => '<username>',
          password       => '<password>',
          syspriv        => 'sysdba|sysasm|sysoper|sysbackup|sysdg|syskm',
          oracle_home    => '<path>',
          connect_string => "[//]host[:port][/service_name][:server][/instance]",
          pluggable      => true|false,
        }

    If you want to manage a remote database, like for instance `DB1`. You will have to specify a local oracle_home from where sqlplus can be started.
    You use `ora_setting` like this:

        ora_setting { 'DB1':
          default        => true,
          user           => 'sys',
          password       => 'password',
          syspriv        => 'sysdba',
          oracle_home    => '/opt/oracle/12.1.0.2/db',
          connect_string => '//host1:1522/DB1',
          pluggable      => false,
        }

    EOD

    # TODO: Find out why this doesn't work
    # def validate
    #   self.fail 'oracle_home MUST be specfied.' if oracle_home.nil? || oracle_home.empty?
    # end

    parameter :name

    property :oracle_home
    property :default
    property :cdb
    property :user
    property :os_user
    property :password
    property :syspriv
    property :connect_string
    property :pluggable
    property :contained_by
  end
end
