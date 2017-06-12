require 'puppet_x/enterprisemodules/oracle/command'
# rubocop: disable Style/ClassAndModuleCamelCase

module Puppet_X
  module EnterpriseModules
    module Oracle
      # docs
      class AsmcmdCommand < Puppet_X::EnterpriseModules::Oracle::Command
        def initialize(options = {})
          super(:asmcmd, options)
        end
      end
    end
  end
end
