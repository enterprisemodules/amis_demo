# encoding: UTF-8
newproperty(:force_logging) do
  include EasyType

  newvalues(:enabled, :disabled)

  desc <<-EOD
    Enable or disable the FORCE LOGGING mode.
  EOD

  to_translate_to_resource do |raw_resource|
    logging = raw_resource.column_data('FORCE_LOGGING')
    if logging == 'YES'
      :enabled
    elsif logging == 'NO'
      :disabled
    else
      nil
    end
  end

  on_apply do
    enabled? ? 'force_logging' : 'noforce_logging'
  end

  on_modify do
    log_clause = should == :enabled ? 'force logging' : 'no force logging'
    statement = "alter database #{log_clause}"
    sql(statement, :sid => resource.name)
    nil
  end

  def insync?(is)
    return true unless resource.contained_by.nil?
    super
  end

  private

  def enabled?
    value == :enabled
  end
end
