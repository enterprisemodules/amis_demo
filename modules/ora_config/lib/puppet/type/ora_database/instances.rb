# encoding: UTF-8

# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassAndModuleChildren

newparam(:instances) do
  # docs
  class ::Puppet::Type::Ora_database::ParameterInstances
    include EasyType
    include Puppet_X::EnterpriseModules::Oracle::Schemas
    include Puppet_X::EnterpriseModules::ExtendHash

    defaultto({})

    desc <<-EOD
    One or more instances to be enables on the database

    Use this syntax to specify all attributes:

        ora_database{'dbname':
          ...
          instances       => {
            instance1   => host1,
            instance2   => host2,
          }
        }
    EOD

    def validate(value)
      fail 'instances should be a hash' unless value.is_a?(Hash)
    end
  end
end
