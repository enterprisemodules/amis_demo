newproperty(:quotas) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::CreateOnly

  desc <<-EOD
    Quota's for this user.
  EOD

  to_translate_to_resource do |raw_resource|
    username = raw_resource.column_data('USERNAME').upcase
    sid = raw_resource.column_data('SID')
    @raw_quotas ||= sql_on_all_database_sids 'select * from dba_ts_quotas'
    quota_for(username, sid)
  end

  def raw_validate(value)
    Puppet.Error 'resource must be a hash like structure' unless value.class == Hash
  end

  def unsafe_munge(value)
    return_value = {}
    value.each do |tablespace_name, quota|
      return_value.merge!(tablespace_name.upcase => quota.to_s)
    end
    return_value
  end

  def insync?(value)
    value == without_null_quotas(should)
  end

  def change_to_s(from, to)
    "changed from #{from.inspect} to #{to.inspect}"
  end

  after_apply do
    if value == {}
      tablespaces.each do |ts|
        sql("ALTER USER #{resource[:username]} QUOTA 0 ON #{ts}", :sid => resource.sid)
      end
    else
      value.collect do |tablespace, quota|
        sql("ALTER USER #{resource[:username]} QUOTA #{quota} ON #{tablespace}", :sid => resource.sid)
      end
    end
  end

  private

  def tablespaces
    statement = "select distinct tablespace_name from dba_tablespaces where contents = 'PERMANENT'"
    sql(statement, :sid => resource.sid).collect { |t| t['TABLESPACE_NAME'] }
  end

  def self.quota_for(user, sid)
    translate(@raw_quotas.select { |q| q['USERNAME'] == user && q['SID'] == sid })
  end

  def self.translate(raw)
    return_value = {}
    raw.each do |raw_line|
      return_value.merge!(tablespace_name(raw_line) => size(raw_line))
    end
    return_value
  end

  def without_null_quotas(quotas)
    Hash[quotas.select { |_k, v| v != '0' }]
  end

  def self.tablespace_name(raw)
    raw['TABLESPACE_NAME']
  end

  def self.size(raw)
    value = raw['MAX_BYTES']
    if value == '-1'
      'unlimited'
    else
      value.to_s
    end
  end
end
