newparam(:parameters) do
  include EasyType

  desc <<-EOD
    The parameters to pass to the sql upgrade and downgrade scripts.

    Sometimes you want to parameterize the upgrade end/or downgrade SQL-scripts. This is supported by the `parameters` property. Here is an example of a definition.

        ora_schema_definition{'MYAPP':
            ensure      => 'latest',
            schema_name => 'MYAPP,
            password    => 'verysecret',
            source_path => '/opt/stage/myapp/sql',
            parameters  => {
              myapp_data_tablespace => 'MYAPP_DATA',
              myapp_idx_tablespace  => 'MYAPP_DATA',
            }
        }

    In the SQL-scripts you can use these parameters like this:

        CREATE TABLE order(
        ...
        ) TABLESPACE &myapp_data_tablespace


  EOD

  defaultto {}
end
