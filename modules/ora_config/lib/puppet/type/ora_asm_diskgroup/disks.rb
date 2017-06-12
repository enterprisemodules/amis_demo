require 'puppet_x/enterprisemodules/oracle/schemas'
require 'puppet_x/enterprisemodules/extend_hash'

newproperty(:disks, :array_matching => :all) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::Schemas
  include Puppet_X::EnterpriseModules::ExtendHash

  desc <<-EOD
    The disks in the diskgroup.

    The disks property is a required hash containing the disk and optionaly the failgroup information for this diskgroup.

    The syntax used for this property depends on the value of the `redundancy_type`. When the `redundancy_type` is set to external,
    no failgroups are used. In that case, the value for the `disks` property is an Array of Hashes, where every Hash contains
    a `diskname` and a `path` key. Here is an example:

        ora_asm__diskgroup {...:
          redundancy_type => 'EXTERN',
          disks => [
              {diskname => 'RECODG_001', path => 'ORCL:RECODG_001'},
              {diskname => 'RECODG_002', path => 'ORCL:RECODG_002'},
            ],
          }
        }


    When the `redundancy_type` is `NORMAL`, or `HIGH`, you *MUST* specfy the fail groups. The `disks` property is a Hash wjere the
    key of the Hash is the name of the failgroup. The value of the Hash, is an Array of disks. A disk element is a Hash, where
    every Hash contains a `diskname` and a `path` key. Here is an example:

        ora_asm__diskgroup {...:
          redundancy_type => 'NORMAL',
          disks => {
            FAILGROUP1 => [
              {diskname => 'RECODG_001', path => 'ORCL:RECODG_001'},
              {diskname => 'RECODG_002', path => 'ORCL:RECODG_002'},
            ],
            FAILGROUP2 => [
              {diskname => 'RECODG_003', path => 'ORCL:RECODG_003'},
              {diskname => 'RECODG_004', path => 'ORCL:RECODG_004'},
            ],
          }
        }

  EOD

  VALIDATION = Puppet_X::EnterpriseModules::Oracle::Schemas::DISKGROUP_DISK

  validate do |value|
    begin
      if resource.redundancy_type =~ /EXTERN(?:AL)?/
        ClassyHash.validate_strict(value, VALIDATION)
      else
        value.each do |_key, disks|
          disks.each { |d| ClassyHash.validate_strict(d, VALIDATION) }
        end
      end
    rescue NoMethodError
      fail "disk value '#{value}' inconsistent with specfied redundancy_type (if any is specfied)."
    end
  end

  to_translate_to_resource do |raw_resource|
    type = raw_resource['TYPE']
    @group_number = raw_resource.column_data('GROUP_NUMBER')
    @sid = raw_resource.column_data('SID')
    sids = running_asm_sids
    @disks ||= sql_on_sids(sids, 'select failgroup, group_number, path, name from v$asm_disk order by group_number, name')
    if type == 'EXTERN'
      failgroups.collect { |fg| disks_in_fg(fg).first }
    else
      Hash[failgroups.collect { |fg| [fg, disks_in_fg(fg)] }]
    end
  end

  munge do |value|
    if failgroup_definition?(value)
      new_value = value.keys.collect do | fg|
        [fg, value[fg].collect{|e| {'diskname' => e['diskname'].upcase, 'path' => e['path']}}]
      end
      Hash[new_value]
    else
      value['diskname'] = value['diskname'].upcase
      value
    end
  end

  def insync?(is)
    # because of the array_matching, the should is always an array
    # To make correct compares, make the is also an array if it isn't already
    is = [is] if is.is_a?(Hash)
    return true if normalized_defintion(is) == normalized_defintion(should)
    if resource['allow_disk_update'] != :true
      Puppet.warning "#{path}: Skipping change in disks for #{resource} because attribute allow_disk_update is set to false."
      true
    else
      false
    end
  end

  def change_to_s(current_value, new_value)
    if resource['redundancy_type'] == 'EXTERN'
      change_to_s_extern(current_value, new_value)
    else
      change_to_s_normal(current_value, new_value.first) # Because array_matching valie is transformed to Array, but it shouldn't
    end
  end

  def change_to_s_extern(current_value, new_value)
    messages = []
    added_disks = (new_value - current_value).collect { |e| e['diskname'] }
    removed_disks = (current_value - new_value).collect { |e| e['diskname'] }
    messages << "Added disks #{added_disks.join(',')}" if added_disks.any?
    messages << "Removed disks #{removed_disks.join(',')}" if removed_disks.any?
    messages.join('; ')
  end

  def change_to_s_normal(current_value, new_value)
    messages = []
    added_failgroups = new_value.keys - current_value.keys
    removed_failgroups = current_value.keys - new_value.keys
    changed_failgroups = current_value.keys.select { |d| current_value[d] != new_value[d] }
    messages << "Added failgroup(s) #{added_failgroups.join(',')} to diskgroup" if added_failgroups.any?
    messages << "Removed failgroup(s) #{removed_failgroups.join(', ')}" if removed_failgroups.any?
    messages << "Changed disk setup for failgroup(s) #{changed_failgroups.join(', ')}" if changed_failgroups.any?
    messages.join('; ')
  end

  on_modify do
    case resource.redundancy_type
    when 'EXTERN', 'EXTERNAL'
      sql template('ora_config/ora_asm_diskgroup/add_disks.sql.erb', binding), :sid => resource.asm_sid if disks_added?
      sql template('ora_config/ora_asm_diskgroup/remove_disks.sql.erb', binding), :sid => resource.asm_sid if disks_removed?
    when 'NORMAL', 'HIGH'
      sql template('ora_config/ora_asm_diskgroup/add_failgroups.sql.erb', binding), :sid => resource.asm_sid if failgroups_added?
      sql template('ora_config/ora_asm_diskgroup/add_disks_to_failgroups.sql.erb', binding), :sid => resource.asm_sid if disks_added_to_failgroups?
      sql template('ora_config/ora_asm_diskgroup/remove_failgroups.sql.erb', binding), :sid => resource.asm_sid if failgroups_removed?
      sql template('ora_config/ora_asm_diskgroup/remove_disks_from_failgroups.sql.erb', binding), :sid => resource.asm_sid if disks_removed_from_failgroups?
    else
      raise 'invalid redundancy_type found'
    end
    nil
  end

  def normalized_defintion(definition)
    if failgroup_definition?(definition)
      definition = definition.first
      value = definition.keys.collect do |fg|
       [fg, normalized_defintion(definition[fg])]
       end
       Hash[value]
    else # Is a set of disks
      definition.sort_by{|e| e['diskname']}
    end
  end

  def failgroup_definition?(param)
    param = [param] unless param.is_a?(::Array)
    #
    # failgroup definitions contain the failgroup name as hash key. disks defeintions,
    # contain the diskname.
    #
    param.none?{ |e|e.keys.include?('diskname')}
  end

  def added_failgroups
    names = value.first.keys - provider.disks.keys
    Hash[names.collect { |n| [n, value.first[n]] }]
  end

  def removed_failgroups
    names = provider.disks.keys - value.first.keys
    Hash[names.collect { |n| [n, provider.disks[n]] }]
  end

  def failgroups_removed?
    removed_failgroups.keys.any?
  end

  def failgroups_added?
    added_failgroups.keys.any?
  end

  def disks_added_to_failgroups
    changed_fgs = value.first.keys.select { |d| value.first[d] != provider.disks[d] }
    disks_added = changed_fgs.collect { |fg| [fg, value.first[fg] - (provider.disks[fg] || [])] }.select { |e| e.last.any? }
    Hash[disks_added]
  end

  def disks_added_to_failgroups?
    disks_added_to_failgroups.any?
  end

  def disks_removed_from_failgroups
    changed_fgs = value.first.keys.select { |d| value.first[d] != provider.disks[d] }
    disks_removed = changed_fgs.collect { |fg| [fg, (provider.disks[fg] || []) - value.first[fg]] }.select { |e| e.last.any? }
    Hash[disks_removed]
  end

  def disks_removed_from_failgroups?
    disks_removed_from_failgroups.any?
  end

  def added_disks
    disks = value.collect { |d| d['diskname'] } - provider.disks.collect { |d| d['diskname'] }
    value.select { |d| disks.include?(d['diskname']) }
  end

  def removed_disks
    disks = provider.disks.collect { |d| d['diskname'] } - value.collect { |d| d['diskname'] }
    provider.disks.select { |d| disks.include?(d['diskname']) }
  end

  def disks_added?
    added_disks.any?
  end

  def disks_removed?
    removed_disks.any?
  end

  def self.failgroups
    @disks.collect do |entry|
      entry['FAILGROUP'] if current_diskgroup?(entry)
    end.compact
  end

  def self.disks_in_fg(fg)
    value = []
    @disks.each do |disk|
      if disk['FAILGROUP'] == fg && current_diskgroup?(disk)
        value << { 'diskname' => disk['NAME'], 'path' => disk['PATH'] }
      end
    end
    value
  end

  def self.failgroup(raw)
    raw['FAILGROUP']
  end

  def self.current_diskgroup?(entry)
    entry['GROUP_NUMBER'] == @group_number && entry['SID'] == @sid
  end
end
