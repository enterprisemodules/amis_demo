require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet/type/ora_tablespace/tablespace_type'
require 'puppet_x/enterprisemodules/oracle/default_sid'
require 'puppet_x/enterprisemodules/oracle/information'

Puppet::Type.newtype(:ora_tablespace) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid
  include Puppet_X::EnterpriseModules::Oracle::Information

  desc <<-EOD
    This type allows you to manage an Oracle tablespace.

    It recognises most of the options that [CREATE TABLESPACE](http://docs.oracle.com/cd/B28359_01/server.111/b28310/tspaces002.htm#ADMIN11359) supports.

        ora_tablespace {'my_app_ts@sid':
          ensure                    => present,
          datafile                  => 'my_app_ts.dbf',
          size                      => 5G,
          logging                   => yes,
          autoextend                => on,
          next                      => 100M,
          max_size                  => 20G,
          extent_management         => local,
          segment_space_management  => auto,
        }

    You can also create an undo tablespace:

        ora_tablespace {'my_undots_1@sid':
          ensure                    => present,
          contents                  => 'undo',
        }

    or a temporary tablespace:

        tablespace {'my_temp_ts@sid':
          ensure                    => present,
          datafile                  => 'my_temp_ts.dbf',
          contents                  => 'temporary',
          size                      => 5G,
          logging                   => yes,
          autoextend                => on,
          next                      => 100M,
          max_size                  => 20G,
          extent_management         => local,
          segment_space_management  => auto,
        }

  EOD

  ensurable

  to_get_raw_resources do
    command = for_version(
      :'12'     => template('ora_config/ora_tablespace/index12.sql.erb', binding),
      :default  => template('ora_config/ora_tablespace/index.sql.erb', binding)
    )
    sql_on_all_database_sids command
  end

  on_create do
    command = "create #{ts_type} #{ts_contents} tablespace \"#{tablespace_name}\""
    command << " segment space management #{segment_space_management}" if segment_space_management
    command << " blocksize #{block_size}" if block_size
    command << " #{ts_encryption}" if encryption
    [:sql, command, {:sid => sid}]
  end

  on_modify do
    # Allow individual properties to do there stuff
  end

  on_destroy do
    [:sql, "drop tablespace \"#{tablespace_name}\" including contents and datafiles", {:sid => sid}]
  end

  map_title_to_sid(:tablespace_name)

  parameter :name
  parameter :tablespace_name
  parameter :sid
  parameter :block_size
  parameter :datafile
  parameter :timeout

  property  :bigfile
  property  :size
  group(:autoextend_group) do
    property  :autoextend
    property  :next
  end
  property  :max_size
  property  :extent_management
  property  :segment_space_management
  property  :logging
  property  :contents
  parameter :encryption

  def ts_type
    (self['bigfile'] == :yes) ? 'bigfile' : ''
  end

  def ts_contents
    (self['contents'] != :permanent) ? self['contents'] : ''
  end

  def ts_encryption
    if self['encryption'].nil?
      ''
    elsif :true
      "encryption default storage (encrypt)"
    else
      "encryption using '#{encryption}' default storage (encrypt)"
    end
  end
end
