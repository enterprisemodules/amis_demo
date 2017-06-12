# encoding: UTF-8
require 'puppet_x/enterprisemodules/oracle/schemas'
require 'puppet_x/enterprisemodules/extend_hash'

# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassAndModuleChildren

newparam(:extent_management) do
  # docs
  class ::Puppet::Type::Ora_database::ParameterExtent_management
    include EasyType
    include Puppet_X::EnterpriseModules::Oracle::Schemas

    newvalues(:local)

    desc <<-EOD
    Specify the extent management.

    Use this syntax to specify all attributes:

        ora_database{'dbname':
          ...
          extent_management => 'local'
        }

    EOD
  end
end
