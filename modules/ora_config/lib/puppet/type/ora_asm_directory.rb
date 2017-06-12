require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/ora_tab'
require 'puppet_x/enterprisemodules/oracle/resources/ora_asm_directory'
require 'puppet/parameter/boolean'

#
# Create a new type oracle_user. Oracle user, works in conjunction
# with the SqlResource provider
#
Puppet::Type.newtype(:ora_asm_directory) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser

  desc <<-EOD
  This type allows you to manage your ASM Directories.

  Like the other Oracle types, it's not mandatory to specify a SID here.
  In that case it will use the ora_setting entry for ASM with the `default` property set to `true`
  If you do specify a SID it must be an ASM sid.
  Most of the times, this is `+ASM`

      ora_asm_directory {'+DATA/DIR/SUBDIR@+ASM':
        ensure          => 'present',
        path            => '+DATA/DIR/SUBDIR'
      }

EOD

  ensurable

  to_get_raw_resources do
    Puppet_X::EnterpriseModules::Oracle::Resources::OraAsmDirectory.raw_resources
  end

  on_create do
    dg = dg(asm_path)
    sql("alter diskgroup #{dg} add directory '#{asm_path}'", :sid => asm_sid)
    nil
  end

  on_modify do
    nil
  end

  on_destroy do
    dg = dg(asm_path)
    sql("alter diskgroup #{dg} drop directory '#{asm_path}'", :sid => asm_sid)
  end

  map_title_to_asm_sid(:asm_path)

  parameter :name
  parameter :asm_sid # The included file is asm_sid, but the parameter is named sid
  parameter :asm_path
  parameter :recurse

  def parent_path(asm_path)
    asm_path.split('/')[0..-2].join('/')
  end

  def dg(asm_path)
    asm_path.split('/')[0].gsub('+','')
  end

  def generate
    #
    # Add news resources to the catalog based on the :asm_path and :recurse parameter
    #
    if recurse
      dg = asm_path.split('/')[0]
      parent_path = parent_path(asm_path)
      hash = to_hash
      hash[:name] = parent_path + '@' + sid
      hash[:asm_path] = parent_path
      if self.ensure == :absent
        hash[:require] = self
      else
        hash[:before] = self
      end
      if parent_path == dg
        hash[:recurse] = false
        nil
      else
        hash[:recurse] = true
        self.class.new(hash)
      end
    end
  end

  autorequire(:ora_asm_diskgroup) { dg(asm_path) }
end
