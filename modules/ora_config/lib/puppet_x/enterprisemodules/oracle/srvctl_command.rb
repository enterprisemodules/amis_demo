require 'puppet_x/enterprisemodules/oracle/command'
# rubocop: disable Style/ClassAndModuleCamelCase

module Puppet_X
  module EnterpriseModules
    module Oracle
      # docs
      class SrvctlCommand < Puppet_X::EnterpriseModules::Oracle::Command
        def initialize(options = {})
          super(:srvctl, options)
        end

        def execute(arguments)
          options = { :failonfail => true, :combine => true }
          value = ''
          command = command_string(arguments)
          within_time(@timeout) do
            Puppet.debug "Executing #{@command} command: #{arguments} as #{os_user}"
            value = Puppet::Util::Execution.execute(command, options)
          end
          value
        end
      end
    end
  end
end
