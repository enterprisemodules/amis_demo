require 'puppet_x/enterprisemodules/oracle/resources/generic'
# rubocop: disable Style/ClassAndModuleCamelCase

module Puppet_X
  module EnterpriseModules
    module Oracle
      module Resources
        # docs
        class OraAsmDirectory < Resources::Generic
          def raw_resources
            statement = template('ora_config/ora_asm_directory/index.sql.erb', binding)
            sql_on_all_asm_sids(statement)
          end
        end
      end
    end
  end
end
