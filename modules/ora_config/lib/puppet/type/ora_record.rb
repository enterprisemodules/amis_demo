require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_record) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This resource allows you to manage a record in an Oracle database table.

    Use ora_record to make sure a record with a specfied primary key exists in the specified table. Here is
    an exaple:

        ora_record{'set_external_service_name':
          ensure     => 'present',
          table_name => 'CONFIG_DATA',
          key_name   => 'CONFIG_ID',
          key_value  => 10,
          username   => 'ORACLE_USER',
          password   => 'verysecret',
          data       => {
            'CONFIG_NAME'  => 'service_name',
            'CONFIG_VALUE' => 'http://external.data-server.com',
            ...
          }
        }

    This Puppet code tells you that the table CONFIG_DATA from user ORACLE_USER must contain a record where
    the primary key CONFIG_ID is 10. If Puppet notices that this record doesn’t exist, It will create the
    record and fill its data with the data specified in the data property. If Puppet sees that the key already
    exists, it does nothing. This code will make sure your database contains the record, but it will not
    ALWAYS set the data. This code is useful for example in use cases where there is a set of management
    screens to manage these settings. Puppet makes sure the setting exists, but will leave the settings
    as they are after the system is running and applications managers might have changed the values.


    If you **always** want to make sure the record contains the specfied data, use `updated` for the `ensure`
    property.

        ora_record{'set_external_service_name':
          ensure     => 'updated',
          table_name => 'CONFIG_DATA',
          username   => 'ORACLE_USER',
          password   => 'verysecret',
          key_name   => 'CONFIG_ID',
          key_value  => 10,
          data       => {
            'CONFIG_NAME'  => 'service_name',
            'CONFIG_VALUE' => 'http://external.data-server.com',
            ...
          }
        }

    Now Puppet will not only check if the record exists, but it will also always make sure the specified columns
    contain the specified values. If there are columns you don’t want to manage, then just leave them blank.

  EOD

  to_get_raw_resources do
    []
  end

  on_create do
    statement = "insert into #{table_name} ( #{key_name} ,#{columns}) values ( '#{key_value}', #{values})"
    [:sql, statement, {:sid => sid, :username => username, :password => password} ]
  end

  on_modify do
    statement = "select * from #{table_name} where #{key_name} = '#{key_value}' for update\;\n"
    statement << "update #{table_name} set #{new_values} where #{key_name} = '#{key_value}'\;\n"
    statement << "commit\n"
    [:sql, statement, {:sid => sid, :username => username, :password => password} ]
  end

  on_destroy do
    statement = "delete from #{table_name} where #{key_name} = '#{key_value}'"
    [:sql, statement, {:sid => sid, :username => username, :password => password} ]
  end

  map_title_to_sid(:name)

  parameter :name
  parameter :username
  parameter :password
  parameter :table_name
  parameter :sid
  parameter :key_value
  parameter :key_name
  property  :data
  property  :ensure

  private

  def columns
    data.keys.join(',').to_s
  end

  def values
    data.values.collect { |v| "'#{v}'" }.join(',')
  end

  def new_values
    data.collect { |k, v| "#{k}='#{v}'" }.join(',')
  end

  ora_autorequire(:ora_user, :username)
end
