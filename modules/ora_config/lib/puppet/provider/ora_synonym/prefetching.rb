require 'puppet_x/enterprisemodules/oracle/access'
require 'easy_type'

Puppet::Type.type(:ora_synonym).provide(:prefetching) do
  include EasyType::Provider
  include Puppet_X::EnterpriseModules::Oracle::Access
  include EasyType::Helpers

  confine :exists => '/etc/ora_setting.yaml'

  desc 'Manage Oracle synonyms in an Oracle Database via regular SQL'

  mk_resource_methods

  def self.instances_for(resources)
    owners = resources.keys.collect { |k| resources[k].owner }.uniq
    raw_resources = sql_on_all_database_sids("select * from dba_synonyms where owner in ('#{owners.join("','")}')")
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
end
