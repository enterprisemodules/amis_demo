# rubocop: disable Style/ClassAndModuleChildren
# docs
class Puppet::Parameter::OracleProfileProperty < Puppet::Property
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access

  def self.translate_to_resource(raw_resource)
    profile = raw_resource.column_data('PROFILE').upcase
    sid = raw_resource.column_data('SID')
    @@raw_resources ||= sql_on_all_database_sids 'select * from dba_profiles'
    value_for(profile, sid)
  end

  on_apply do
    "#{name} #{value} "
  end

  def self.value_for(profile, sid)
    @@raw_resources.select { |q| q['PROFILE'] == profile && q['SID'] == sid && q['RESOURCE_NAME'] == name.to_s.upcase }.first['LIMIT']
  end
end
