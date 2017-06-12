require 'digest/sha1'
# rubocop: disable Style/ClassAndModuleCamelCase

module Puppet_X
  module EnterpriseModules
    module Oracle
      # docs
      module CreateOnly
        def insync?(is)
          create_only_insync?(is, should)
        end

        def update?
          resource.provider.ensure != :absent
        end

        def create_only?
          resource[:create_only].include?(name.to_s)
        end

        def create_only_insync?(is, should)
          if update? && create_only?
            Puppet.info "Skipping property change of #{name}, bause it is on the create_only list." if is != should
            true
          else
            is == should
          end
        end
      end
    end
  end
end
