require 'puppet_x/enterprisemodules/oracle/access'
require 'easy_type'

Puppet::Type.type(:ora_object_grant).provide(:prefetching) do
  include EasyType::Provider
  include EasyType::Helpers
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::Information

  confine :exists => '/etc/ora_setting.yaml'

  desc 'Manage Oracle object permissions via regular SQL'

  mk_resource_methods

  def self.all_resources
    statement = for_version(
      :'12'     => "select distinct grantee, common, privilege, grantable ,  owner || '.' || table_name object from dba_tab_privs",
      :default  => "select distinct grantee, privilege, grantable ,  owner || '.' || table_name object from dba_tab_privs"
    )
    merge_multiple_values(sql_on_all_database_sids(statement))
  end

  def self.instances_for(resources)
    grantees = resources.keys.collect { |k| resources[k].grantee }.uniq
    raw_resources = merge_multiple_values(sql_on_all_database_sids("select distinct grantee, privilege, grantable ,  owner || '.' || table_name object from dba_tab_privs where grantee in ('#{grantees.join("','")}')"))
    raw_resources.map do |raw_resource|
      map_raw_to_resource(raw_resource)
    end
  end

  def self.prefetch(resources)
    objects = instances_for(resources)
    resources.keys.each do |name|
      provider = objects.find { |object| object.name == name }
      resources[name].provider = provider if provider
    end
  end

  private

  def self.with_multiple_values(set)
    keys = set.map { |p| "#{p['OBJECT']}:#{p['GRANTEE']}@#{p['SID']}" }
    keys.group_by { |e| e }.select { |_k, v| v.size > 1 }.map(&:first)
  end

  def self.multiple_value_set(_k)
    keys = set.map { |p| "#{p['OBJECT']}:#{p['GRANTEE']}@#{p['SID']}" }
    keys.group_by { |e| e }.select { |_k, v| v.size > 1 }.map(&:first)
  end

  #
  # Merge parameter values if there are multiple values
  #
  def self.merge_multiple_values(set)
    multiples = with_multiple_values(set)
    newset = []
    multiple_values_set = set.select { |e| multiples.include?("#{e['OBJECT']}:#{e['GRANTEE']}@#{e['SID']}") }
    multiples.each do |parameter|
      # TODO: Refacter. This is way to complex
      #
      values = multiple_values_set.select { |e| "#{e['OBJECT']}:#{e['GRANTEE']}@#{e['SID']}" == parameter && e['GRA'] == 'NO'}
      regular_values = {}.tap { |r| values.each { |h| h.each { |k, v| (k == 'PRIVILEGE') ? ((r['PRIVILEGE'] ||= []) << v) : (r[k] = v) } } }
      values = multiple_values_set.select { |e| "#{e['OBJECT']}:#{e['GRANTEE']}@#{e['SID']}" == parameter && e['GRA'] == 'YES'}
      granted_values = {}.tap { |r| values.each { |h| h.each { |k, v| (k == 'PRIVILEGE') ? ((r['GRANTED_PRIVS'] ||= []) << v) : (r[k] = v) } } }
      values = regular_values.merge(granted_values)
      newset << EasyType::Helpers::InstancesResults[values]
    end
    set.delete_if { |e| multiples.include?("#{e['OBJECT']}:#{e['GRANTEE']}@#{e['SID']}") }
    set.each do |row|
      if row['GRA'] == 'YES'
        row['GRANTED_PRIVS']= row['PRIVILEGE']
        row['PRIVILEGE'] = nil
      end
    end
    set + newset
  end
end
