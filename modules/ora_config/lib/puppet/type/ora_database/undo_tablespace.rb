# encoding: UTF-8
require 'puppet_x/enterprisemodules/oracle/schemas'
require 'puppet_x/enterprisemodules/extend_hash'
# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassAndModuleChildren

newparam(:undo_tablespace) do
  # Docs
  class ::Puppet::Type::Ora_database::ParameterUndo_tablespace
    include EasyType
    include Puppet_X::EnterpriseModules::Oracle::Schemas
    include Puppet_X::EnterpriseModules::ExtendHash

    desc <<-EOD
    Specify the default tablespace.

    Use this syntax to specify all attributes:

        ora_database{'dbname':
          ...
          undo_tablespace => {
            name      => 'UNDOTBS',
            type      => 'bigfile',
            datafile  => {
              file_name  => 'undo.dbs',
              size       => '10G',
              reuse      =>  true,
            }
          }
        }

    EOD

    DATAFILE          = Puppet_X::EnterpriseModules::Oracle::Schemas::DATAFILE
    EXTENT_MANAGEMENT = Puppet_X::EnterpriseModules::Oracle::Schemas::EXTENT_MANAGEMENT
    TABLESPACE_TYPE   = Puppet_X::EnterpriseModules::Oracle::Schemas::TABLESPACE_TYPE

    VALIDATION = {
      'name'               => String,
      'type'               => [:optional, TABLESPACE_TYPE],
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
      command_segment = "#{value_for('type')} undo tablespace #{value_for('name')}"
      command_segment << " datafile #{datafiles(datafile_data)}" if exists?('datafile')
      command_segment
    end
  end
end
