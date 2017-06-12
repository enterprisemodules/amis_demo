require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_init_param) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This resource allows you to manage Oracle parameters.

    this type allows you to manage your init.ora parameters. You can manage your `spfile` parameters and your `memory`
    parameters. First the easy variant where you want to change an spfile parameter on your current sid for your current sid.

        ora_init_param{'SPFILE/PARAMETER':
          ensure  => present,
          value   => 'the_value'
        }

    To manage the same parameter only the in-memory one, use:

        init_param{'MEMORY/PARAMETER':
          ensure  => present,
          value   => 'the_value'
        }

    If you are running RAC and need to specify a parameter for an other instance, you can specify the instance as well.

        init_param{'MEMORY/PARAMETER:INSTANCE':
          ensure  => present,
          value   => 'the_value'
        }

    Having more then one sid running on your node and you want to specify the sid you want to use, use `@SID` at the end.

        init_param{'MEMORY/PARAMETER:INSTANCE@SID':
          ensure  => present,
          value   => 'the_value'
        }

  EOD

  ensurable

  to_get_raw_resources do
    specified_parameters_for(memory) + specified_parameters_for(spfile)
  end

  validate do
    fail 'Parameter for_sid is invalid when specifying a memory parameter' if scope.to_s == 'MEMORY' && for_sid
  end

  def apply
    statement = "alter system set \"#{parameter_name}\"=#{specified_value} scope=#{scope}"
    statement += " sid='#{for_sid}'" if scope == 'SPFILE'
    [:sql, statement, { :sid => sid }]
  end

  on_create do
    apply
  end

  on_modify do
    apply
  end

  on_destroy do
    [:sql, "alter system reset \"#{parameter_name}\" scope=#{scope} sid='#{for_sid}'", { :sid => sid }]
  end

  parameter :name
  parameter :parameter_name
  parameter :sid
  parameter :scope
  parameter :for_sid

  property  :value

  private

  def specified_value
    fail 'ora_init_param must contain a value' unless self[:value]
    value = self[:value].size <= 1 ? self[:value].first : self[:value]
    if number?(value) || boolean?(value)
      value
    elsif value.is_a?(Array)
      value.map { |e| "'#{e}'" }.join(',')
    else
      "'#{value}'"
    end
  end

  def number?(value)
    (begin
       Integer(value)
     rescue
       false
     end) && true
  end

  def boolean?(value)
    case value
    when 'TRUE', 'FALSE', 'true', 'false' then return true
    end
    !!value == value
  end

  map_titles_to_attributes([
    %r{^((MEMORY|SPFILE|memory|spfile)\/(.*):(.*)@(.*))$}, [:name, :scope, :parameter_name, :for_sid, :sid],
    %r{^((MEMORY|SPFILE|memory|spfile)\/(.*)@(.*))$},      [:name, :scope, :parameter_name, :sid],
    %r{^((MEMORY|SPFILE|memory|spfile)\/(.*):(.*))$},      [:name, :scope, :parameter_name, :for_sid],
    %r{^((MEMORY|SPFILE|memory|spfile)\/(.*))$},           [:name, :scope, :parameter_name]
  ])

  def self.specified_parameters_for(set)
    set = without_empty_values(set)
    merge_multiple_values(set)
  end

  #
  # Because the display_value column can contain strings with a quote, we check it for those
  # quotes. If a quote is found, we translate it to a double quote. The double quote
  # will be handled by easy_types convert_csv_data_to_hash routne and translated back to a
  # normal quote in the value string.
  #
  def self.memory
    sql_on_all_sids "select 'MEMORY' as scope, t.issys_modifiable, t.name, rawtohex(t.display_value) as display_value, b.instance_name as for_sid  from gv$parameter t, gv$instance b where t.inst_id = b.instance_number and t.issys_modifiable <> 'FALSE'"
  end

  def self.spfile
    sql_on_all_sids "select 'SPFILE' as scope, isspecified, name, rawtohex(display_value) as display_value, sid as for_sid from v$spparameter where isspecified = 'TRUE'"
  end

  def self.without_empty_values(set)
    set.select { |p| p['DISPLAY_VALUE'] != '' }
  end

  #
  # Returns the parameters that have multiple values
  #
  def self.with_multiple_values(set)
    keys = set.map { |p| "#{p['NAME']}:#{p['FOR_SID']}@#{p['SID']}" }
    keys.find_all { |e| keys.count(e) > 1 }.uniq
  end

  #
  # Merge parameter values if there are multiple values
  #
  def self.merge_multiple_values(set)
    multiples = with_multiple_values(set)
    multiples.each do |parameter|
      values = set.select { |e| "#{e['NAME']}:#{e['FOR_SID']}@#{e['SID']}" == parameter }
      values = {}.tap { |r| values.each { |h| h.each { |k, v| k == 'DISPLAY_VALUE' ? ((r[k] ||= []) << v) : (r[k] = v) } } }
      set.delete_if { |e| "#{e['NAME']}:#{e['FOR_SID']}@#{e['SID']}" == parameter }
      set << EasyType::Helpers::InstancesResults[values]
    end
    set
  end

end
