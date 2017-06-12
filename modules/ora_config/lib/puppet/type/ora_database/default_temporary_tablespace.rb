# encoding: UTF-8
require 'puppet_x/enterprisemodules/oracle/schemas'
require 'puppet_x/enterprisemodules/extend_hash'

# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassAndModuleChildren

newparam(:default_temporary_tablespace) do
  # docs
  class ::Puppet::Type::Ora_database::ParameterDefault_temporary_tablespace
    include EasyType
    include Puppet_X::EnterpriseModules::Oracle::Schemas
    include Puppet_X::EnterpriseModules::ExtendHash

    desc <<-EOD
    Specify the default temporary tablespace.

    Use this syntax to specify all attributes:

        ora_database{'dbname':
          ...
          default_temporary_tablespace => {
            name      => 'TEMP',
            tempfile  => {
              file_name  => 'tmp.dbs',
              size       => '10G',
              reuse      =>  true,
              autoextend => {
                maxsize => 'unlimited',
                next    => '1G',
              }
            }
            extent_management => {
              type          => 'local',
              autoallocate  => true, (mutual exclusive with uniform segment size)
              uniform_size  => '5G',
            }
          }
        }

    EOD

    TEMPFILE          = Puppet_X::EnterpriseModules::Oracle::Schemas::DATAFILE
    EXTENT_MANAGEMENT = Puppet_X::EnterpriseModules::Oracle::Schemas::EXTENT_MANAGEMENT
    TABLESPACE_TYPE   = Puppet_X::EnterpriseModules::Oracle::Schemas::TABLESPACE_TYPE

    VALIDATION = {
      'name'               => String,
      'type'               => [:optional, TABLESPACE_TYPE],
      'tempfile'           => [:optional, DATAFILE],
      'extent_management'  => [:optional, EXTENT_MANAGEMENT]
    }.freeze

    def validate(value)
      ClassyHash.validate_strict(value, VALIDATION)
      use_hash(value)
      validate_extent_management(value_for('extent_management'))
    end

    def value
      use_hash(@value)
      tempfile_data = value_for('tempfile')
      command_segment = "#{value_for('type')} default temporary tablespace #{value_for('name')}"
      command_segment << " tempfile #{datafiles(tempfile_data)}" if exists?('tempfile')
      command_segment << " #{extent_management(value_for('extent_management'))}" if exists?('extent_management')
      command_segment << "\n"
      command_segment
    end
  end
end
