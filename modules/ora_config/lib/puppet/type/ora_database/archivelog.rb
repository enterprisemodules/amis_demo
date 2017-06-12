newproperty(:archivelog) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access

  newvalues(:enabled, :disabled)

  desc <<-EOD
    Enable or disable archive log.
  EOD

  to_translate_to_resource do |raw_resource|
    log_mode = raw_resource.column_data('LOG_MODE')
    if log_mode == 'ARCHIVELOG'
      :enabled
    elsif log_mode == 'NOARCHIVELOG'
      :disabled
    else
      nil
    end
  end

  on_apply do
    enabled? ? 'archivelog' : 'noarchivelog'
  end

  on_modify do
    log_mode = enabled? ? 'archivelog' : 'noarchivelog'
    statement = template('ora_config/ora_database/archivelog.sql.erb', binding)
    sql(statement, :sid => resource.name)
    nil
  end

  def insync?(is)
    return true if resource.contained_by
    super
  end

  private

  def enabled?
    value == :enabled
  end
end
