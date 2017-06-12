require 'puppet_x/enterprisemodules/oracle/settings'

module Puppet
  module Parser
    # TODO: Docs
    module Functions
      #
      # This function will return an array of all sids registered in the ora_settings
      # file
      newfunction(:available_sids, :type => :rvalue) do |_args|
        extend Puppet_X::EnterpriseModules::Oracle::Settings

        database_sids
      end
    end
  end
end
