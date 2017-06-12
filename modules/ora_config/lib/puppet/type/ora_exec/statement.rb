newproperty(:statement) do
  include Puppet_X::EnterpriseModules::Oracle::Access
  include EasyType::Helpers

  desc <<-EOD
    The sql command to execute.

    This is a required string value. The value must either contain a valid SQL statement:

        ora_exec { 'select * from tab@sid':
        }

    or a valid script name.

        ora_exec { '@/tmp/valid_sql_script.sql@sid':
        }

    when you don't specify a directory, Puppet will use the default directory specified in the
    `cwd` parameter.

        ora_exec { '@valid_sql_script.sql@sid':
          ...
          cwd => '/tmp',
        }

  EOD

  #
  # Let the insync? check for the parameter unless and the refreshonly
  #
  def insync?(_to)
    if resource[:refreshonly] == :true
      # For now we are in sync. On the refresh lets see again how the state is.
      true
    else
      resource[:unless] ? !provider.unless_value? : false
    end
  end


end
