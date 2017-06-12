newproperty(:directory_path) do
  include EasyType

  desc <<-EOD
  	The physical pathname of the directory on the filesystem.

        ora_directory { 'ORACLE_OCM_CONFIG_DIR2@test':
        	...
          directory_path => '/opt/oracle/app/11.04/ccr/state',
          ...
        }

	EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('DIRECTORY_PATH')
  end
end
