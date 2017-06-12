# encoding: UTF-8
require 'puppet_x/enterprisemodules/oracle/schemas'
require 'puppet_x/enterprisemodules/extend_hash'

# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassAndModuleChildren

newparam(:default_tablespace) do
  # docs
  class ::Puppet::Type::Ora_database::ParameterDefault_tablespace
    include EasyType
    include Puppet_X::EnterpriseModules::Oracle::Schemas
    include Puppet_X::EnterpriseModules::ExtendHash

    desc <<-EOD
    Specify the default tablespace.

    Use this syntax to specify all attributes:

        ora_database{'dbname':
          ...
          default_tablespace => {
            name      => 'USERS',
            datafile  => {
              file_name  => 'users.dbs',
              size       => '10G',
              reuse      =>  true,
            }
            extent_management => {
              type          => 'local',
              autoallocate  => true, (mutual exclusive with uniform size)
              uniform_size  => '5G',
            }
          }
        }

    EOD

    DATAFILE          = Puppet_X::EnterpriseModules::Oracle::Schemas::DATAFILE
    EXTENT_MANAGEMENT = Puppet_X::EnterpriseModules::Oracle::Schemas::EXTENT_MANAGEMENT

    VALIDATION = {
      'name'               => String,
      'datafile'           => [:optional, DATAFILE],
      'extent_management'  => [:optional, EXTENT_MANAGEMENT]
    }.freeze

    def validate(value)
      ClassyHash.validate_strict(value, VALIDATION)
      use_hash(value)
      validate_extent_management(value_for('extent_management'))
    end

    def value
      use_hash(@value)
      datafile_data = value_for('datafile')
      command_segment = "default tablespace #{value_for('name')}"
      command_segment << " datafile #{datafiles(datafile_data)}" if exists?('datafile')
      command_segment << " #{extent_management(value_for('extent_management'))}" if exists?('extent_management')
      command_segment
    end
  end
end
