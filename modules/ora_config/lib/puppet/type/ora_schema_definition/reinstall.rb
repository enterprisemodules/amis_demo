newparam(:reinstall) do
  desc <<-EOD
    Force delete before applying the schema updates.


    When you set the `reinstall` property to `true`, Puppet will drop all database objects for the specified
    user and will re-run all the upgrade scripts until the specified version is reached. This feature comes
    in very handy when you use Puppet in your CI environment. Puppet makes sure all old stuff is removed and
    al the tables and indexes are in a pristine state before you start your tests.

    Here is an example on how to use it:

        ora_schema_definition{'MYAPP':
          ...
          reinstall => true,
          ...
        }

  EOD

  newvalues(:true, :false)

  defaultto(:false)
end
