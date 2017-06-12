$LOAD_PATH.unshift(Pathname.new(__FILE__).parent.parent.parent.parent + 'easy_type/lib')
$LOAD_PATH.unshift(Pathname.new(__FILE__).parent.parent)
require 'facter'
require 'puppet'
begin
  require 'puppet/type/ora_asm_diskgroup'
  require 'puppet/type/ora_asm_volume'
# rubocop: disable Lint/HandleExceptions
rescue

end

Facter.add('ora_asm_running') do

  setcode do
    `pgrep -f "^asm_pmon_.+$"` != ''
  end
end


Facter.add('ora_asm_diskgroups') do
  confine :ora_asm_running => true

  setcode do
    Puppet_X::EnterpriseModules::Oracle::Resources::OraAsmDiskgroup.index
  end
end

Facter.add('ora_asm_volumes') do
  confine :ora_asm_running => true

  setcode do
    Puppet_X::EnterpriseModules::Oracle::Resources::OraAsmVolume.index
  end
end
