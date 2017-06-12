newparam(:report_errors) do
  desc <<-EOD
    Report any errors in the SQL scripts.

    When you set this value to true, the type will report any errors that occur in the SQL statements or scripts
    and stop processing. When you set it to `false`, it will ignore any SQL errors and just continue processing.
    The default value is `true`, so it will stop processing when an SQL error is generated.

    Here is an example:

        ora_exec{'delete from user_config':
          ...
          report_errors => true,

        }
  EOD

  newvalues(:true, :false)
  defaultto(:true)
end

def report_errors
  case self[:report_errors]
  when :true
    true
  when :false
    false
  else
    fail 'invalid value for report_errors'
  end
end
