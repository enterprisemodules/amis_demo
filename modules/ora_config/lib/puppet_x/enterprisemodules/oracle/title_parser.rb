require 'puppet_x/enterprisemodules/oracle/access'
# rubocop: disable Style/ClassAndModuleCamelCase

module Puppet_X
  module EnterpriseModules
    module Oracle
      # Docs
      module TitleParser
        include Puppet_X::EnterpriseModules::Oracle::Access

        def map_title_to_sid(*attributes, &proc)
          map_title_to_sid_internal(*(attributes << :sid), &proc)
        end

        def map_title_to_asm_sid(*attributes, &proc)
          map_title_to_sid_internal(*(attributes << :asm_sid), &proc)
        end

        # @private
        def map_title_to_sid_internal(*attributes, &proc)
          sid_parameter = attributes.pop
          base_regexp = proc ? yield : /(.+)/
          without_sid_regexp = Regexp.new("^(#{base_regexp.source})$")
          with_sid_regexp    = Regexp.new("^(#{base_regexp.source}@(.*))$")
          map_titles_to_attributes([
            with_sid_regexp,    [:name] + attributes + [sid_parameter],
            without_sid_regexp, [:name] + attributes
          ])
        end
      end
    end
  end
end
