newparam(:directory_name) do
  include EasyType
  include EasyType::Validators::Name

  desc <<-EOD

    This is the name of the directory inside of the database. In this example:

        ora_directory { 'ORACLE_OCM_CONFIG_DIR2@test':
          ensure         => 'present',
          directory_path => '/opt/oracle/app/11.04/ccr/state',
        }

    it is the `ORACLE_OCM_CONFIG_DIR2` part of the title.

  EOD

  desc 'The directory name'

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('DIRECTORY_NAME').upcase
  end
end
