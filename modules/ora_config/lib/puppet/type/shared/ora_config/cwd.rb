
newparam(:cwd) do
  desc <<-EOD
    The default directory from where the scripts will be run. If not specfied, this will be /tmp.

        ora_exec {...:
          ...
          cwd => '/opt/my_scripts'
        }

  This parameter is convenient when the script you run, expects a default directory. For example
  when running other scripts, without a specfied directory:

      @execute.sql


  EOD
end
