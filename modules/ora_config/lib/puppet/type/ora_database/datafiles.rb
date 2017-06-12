# encoding: UTF-8
require 'puppet_x/enterprisemodules/oracle/schemas'
require 'puppet_x/enterprisemodules/extend_hash'

# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassAndModuleChildren

newparam(:datafiles, :array_matching => :all) do
  # docs
  class ::Puppet::Type::Ora_database::ParameterDatafiles
    include EasyType
    include Puppet_X::EnterpriseModules::Oracle::Schemas
    include Puppet_X::EnterpriseModules::ExtendHash

    desc <<-EOD
    One or more files to be used as datafiles.

    Use this syntax to specify all attributes:

        ora_database{'dbname':
          ...
          datafiles       => [
            {file_name   => 'file1.dbs', size => '10G', reuse => true},
            {file_name   => 'file2.dbs', size => '10G', reuse => true},
          ]
        }

    EOD

    VALIDATION = Puppet_X::EnterpriseModules::Oracle::Schemas::DATAFILE

    def validate(value)
      value = [value] if value.is_a?(Hash) # ensure, it is an array
      value.each { |v| ClassyHash.validate_strict(v, VALIDATION) }
    end

    def value
      "datafile #{datafiles(@value)}" unless @value.empty?
    end
  end
end
