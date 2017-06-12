require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/ora_tab'
require 'puppet_x/enterprisemodules/oracle/access'

# rubocop: disable Style/ClassAndModuleCamelCase

module Puppet_X
  module EnterpriseModules
    module Oracle
      module Resources
        # docs
        class Generic
          include Puppet_X::EnterpriseModules::Oracle::Access
          include EasyType

          def initialize
            @resource_type = host_class
            @oratab        = Puppet_X::EnterpriseModules::Oracle::OraTab.new
          end

          def self.raw_resources
            new.raw_resources
          end

          def self.index
            new.index
          end

          def index
            raw_resources.collect do |raw_resource|
              map_raw_to_resource(raw_resource)
            end
          end

          private

          def host_class_name
            self.class.name.split('::').last.gsub!(/(.)([A-Z])/, '\1_\2').capitalize
          end

          def host_class
            ::Puppet::Type.const_get(host_class_name)
          end

          def map_raw_to_resource(raw_resource)
            resource = {}
            non_meta_parameter_classes.each do |parameter_class|
              resource[parameter_class.name.to_s] = parameter_class.translate_to_resource(raw_resource) if translation?(parameter_class)
            end
            resource
          end

          # @private
          def non_meta_parameter_classes
            @resource_type.properties + non_meta_parameters.map { |param| @resource_type.paramclass(param) }
          end

          # @private
          def non_meta_parameters
            @resource_type.parameters - @resource_type.metaparams
          end

          def translation?(parameter_class)
            defined?(parameter_class.translate_to_resource)
          end
        end
      end
    end
  end
end
