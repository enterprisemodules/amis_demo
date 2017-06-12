# rubocop: disable Style/ClassAndModuleCamelCase
module Puppet_X
  module EnterpriseModules
    module Oracle
      # docs
      module Commands
        def self.included(parent)
          parent.extend(Commands)
        end

        [:asmcmd, :srvctl, :orapwd].each do |command|
          file  = "puppet_x/enterprisemodules/oracle/#{command}_command"
          klass = "#{command.to_s.capitalize}Command"
          require file

          module_eval(<<-END_RUBY, __FILE__, __LINE__)
            # @nodoc
            # @private
            def #{command}( arguments, options = {})
              #{command} = Puppet_X::EnterpriseModules::Oracle::#{klass}.new(options)
              #{command}.execute arguments
            end
          END_RUBY
        end
      end
    end
  end
end
