require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/commands'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/resources/ora_asm_volume'

# @nodoc
Puppet::Type.newtype(:ora_asm_volume) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Commands
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser

  desc <<-EOD
  This type allows you to manage ASM volumes.

  Here is an example on defining an ACFS volume:

      ora_asm_volume{diskgroup:my_volume@+ASM1":
        size          => '10G',
        volume_device => '/mnt/oravolume',
      }

  Before you can issue this definition, the diskgroup must already exists.

  EOD

  ensurable

  to_get_raw_resources do
    Puppet_X::EnterpriseModules::Oracle::Resources::OraAsmVolume.raw_resources
  end

  on_create do
    asmcmd("volcreate -G #{diskgroup} -s #{size}M #{volume_name}", :sid => asm_sid)
  end

  on_modify do
    Puppet.warning "#{path}: Modification of asm volumes not supported yet."
    nil
  end

  on_destroy do
    asmcmd("voldelete -G #{diskgroup} #{volume_name}", :sid => asm_sid)
  end

  map_title_to_asm_sid(:diskgroup, :volume_name) { /(.+):(.+)/ }

  #
  # property  :new_property  # For every property and parameter create a parameter file
  #
  parameter :name
  parameter :asm_sid # The included file is asm_sid, but the parameter is named sid
  parameter :volume_name
  parameter :diskgroup
  parameter :volume_device

  property  :size
  # -- end of attributes -- Leave this comment if you want to use the scaffolder

  #
end
