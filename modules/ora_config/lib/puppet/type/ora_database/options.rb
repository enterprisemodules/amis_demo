# encoding: UTF-8

newparam(:options, :array_matching => :all) do
  desc <<-EOD
    Specify the options that need to be enabled in the database.

        ora_database{'dbname':
          ...
          options => [
              'OWM',
              'JServer',
              'CTX',
              'ORD',
              'IM',
              'OLAP',
              'SDO',        # Requires XDB(default), JServer and ORD
              'OLS',
              'Sample',     # Requires installation of Oracle Database Examples
              'APEX',
              'DV'
            ],
        }

  EOD

  defaultto []
end
