require 'puppet_x/enterprisemodules/oracle/access'
require 'easy_type/helpers'
require 'puppet_x/enterprisemodules/oracle/ora_tab'
require 'fileutils'

Puppet::Type.type(:ora_exec).provide(:sqlplus) do
  include Puppet_X::EnterpriseModules::Oracle::Access
  include EasyType::Helpers
  include EasyType::Template

  confine :exists => '/etc/ora_setting.yaml'

  mk_resource_methods

  def flush
    return if resource[:refreshonly] == :true
    execute
  end

  def unless_value?
    sid = sid_from_resource
    options = { :sid => sid }
    options[:username] = resource[:username] if resource[:username]
    options[:password] = resource[:password] if resource[:password]
    rows = sql resource[:unless], options
    if !rows.empty?
      Puppet.info "#{resource.path}: unless value is true. So statement is not executed."
      return false
    else
      Puppet.info "#{resource.path}: unless value is false. So statement is executed."
      return true
    end
  end

  def execute
    cwd           = resource[:cwd]
    statement     = resource[:statement]
    sid           = sid_from_resource
    options       = { :sid => sid, :parse => false }
    options[:catch_errors] = resource.mark_as_error unless resource.mark_as_error.nil?
    options[:failonsqlfail] = resource.report_errors
    options[:username] = resource.username unless resource.username.nil?
    options[:password] = resource.password unless resource.password.nil?

    fail "Working directory '#{cwd}' does not exist" if cwd && !File.directory?(cwd)
    FileUtils.cd(resource[:cwd]) if resource[:cwd]
    output = sql statement, options
    Puppet.debug(output) if resource.logoutput == :true
  end

  private

  def is_script?(statement)
    statement[0] == 64
  end
end
