require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/ora_tab'
require 'puppet_x/enterprisemodules/oracle/resources/ora_asm_diskgroup'

#
# Create a new type oracle_user. Oracle user, works in conjunction
# with the SqlResource provider
#
Puppet::Type.newtype(:ora_asm_diskgroup) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser

  desc <<-EOD
  This type allows you to manage your ASM diskgroups.

  Like the other Oracle types, you must specify the SID. But for this type it must be the ASM sid.
  Most of the times, this is `+ASM1`

      ora_asm_diskgroup {'REDO@+ASM1':
        ensure          => 'present',
        redundancy_type => 'normal',
        compat_asm      => '11.2.0.0.0',
        compat_rdbms    => '11.2.0.0.0',
        disks           => {
          'FAILGROUP1' => [
            { 'diskname' => 'REDOVOL1', 'path' => 'ORCL:REDOVOL1'}
          ],
          'FAILGROUP2' => [
            { 'diskname' => 'REDOVOL2', 'path' => 'ORCL:REDOVOL2'},
          ]
        }
      }

EOD

  ensurable

  to_get_raw_resources do
    Puppet_X::EnterpriseModules::Oracle::Resources::OraAsmDiskgroup.raw_resources
  end

  on_create do
    statement = if redundancy_type =~ /EXTERN(?:AL)?/
                  template('ora_config/ora_asm_diskgroup/create.sql.erb', binding)
                else
                  template('ora_config/ora_asm_diskgroup/create_diskgroup.sql.erb', binding)
                end
    sql(statement, :sid => asm_sid)
  end

  on_modify do
    nil # Allow the properties to do their own updates
  end

  on_destroy do
    statement = template('ora_config/ora_asm_diskgroup/destroy.sql.erb', binding)
    sql(statement, :sid => asm_sid)
  end

  map_title_to_asm_sid(:groupname)

  parameter :name
  parameter :groupname
  parameter :asm_sid # The included file is asm_sid, but the parameter is named sid
  parameter :force
  parameter :allow_disk_update

  parameter :diskgroup_state
  property  :redundancy_type
  property  :au_size
  property  :compat_asm
  property  :compat_rdbms
  property  :disks

  private

  def attributes
    [:au_size, :compat_asm, :compat_rdbms].collect do |attribute|
      parameters[attribute].to_sql if parameters[attribute]
    end.compact
  end
end
