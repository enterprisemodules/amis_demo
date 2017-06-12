# encoding: UTF-8
newproperty(:autostart) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Settings

  desc <<-EOD
    Add autostart to the oratab entry.
  EOD

  newvalues(:true, :false)

  defaultto(:true)

  to_translate_to_resource do |raw_resource|
    oratab = Puppet_X::EnterpriseModules::Oracle::OraTab.new
    sid = raw_resource['SID']
    if oratab.entry_exists?(sid)
      oratab.entry_autostart?(sid) == 'Y' ? :true : :false
    else
      nil
    end
  end

  on_modify do
    if should == :true
      old_autostart = 'N'
      autostart = 'Y'
    elsif should == :false
      old_autostart = 'Y'
      autostart = 'N'
    end
    oratab = Puppet_X::EnterpriseModules::Oracle::OraTab.new
    if oratab.entry_exists?(resource.name)
      oracle_home = oratab.entry_for(resource.name)[:home]
      oratab.remove_entry(resource.name, oracle_home, old_autostart)
      oratab.ensure_entry(resource.name, oracle_home, autostart)
    end
  end

  def insync?(is)
    return true unless resource.contained_by.nil?
    super
  end
end

def autostart
  self[:autostart] == :true ? 'Y' : 'N'
end
