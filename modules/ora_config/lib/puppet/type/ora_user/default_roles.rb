newproperty(:default_roles, :array_matching => :all) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::CreateOnly
  include EasyType::ArrayProperty
  include EasyType::Mungers::Upcase

  desc "The user's default roles"

  to_translate_to_resource do |raw_resource|
    user = raw_resource['USERNAME']
    sid  = raw_resource['SID']
    roles = sql "select granted_role, default_role from dba_role_privs where grantee='#{user}'", :sid => sid
    roles.collect { |e| default_role?(e) ? e['GRANTED_ROLE'] : nil }.compact
  end

  def insync?(is)
    if should == ['ALL'] || should == ['NONE']
      #
      # Only refetch the roles when we are using ALL or NONE
      #
      return true if is_all?(raw_roles) && should == ['ALL']
      return true if is_none?(raw_roles) && should == ['NONE']
    end
    is.sort == should.sort
  end

  def raw_roles
    @raw_roles ||= sql "select granted_role, default_role from dba_role_privs where grantee='#{provider.username}'", :sid => resource.sid
  end

  def change_to_s(from, to)
    case to
    when ['ALL']
      "changed from #{from.inspect} to ['ALL']"
    when ['NONE']
      "changed from #{from.inspect} to ['NONE']"
    else
      super(from, to)
    end
  end

  after_apply do
    sql("alter user #{resource[:username]} default role #{resource[:default_roles].join(',')}", :sid => resource.sid)
  end

  def self.default_role?(role_record)
    role_record['DEF'] == 'YES'
  end

  def default_role?(role_record)
    self.class.default_role?(role_record)
  end

  def is_all?(roles)
    roles.all? { |e| default_role?(e) }
  end

  def is_none?(roles)
    roles.all? { |e| !default_role?(e) }
  end
end
