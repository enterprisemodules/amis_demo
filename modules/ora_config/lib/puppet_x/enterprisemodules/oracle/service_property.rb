module Puppet_X
  module EnterpriseModules
    module Oracle
      # Docs
      module ServiceProperty
        def self.included(parent)
          parent.send(:include, Puppet_X::EnterpriseModules::Oracle::Access)
          parent.send(:include, Puppet_X::EnterpriseModules::Oracle::Information)
          parent.send(:include, EasyType)
          parent.extend(ClassMethods)
        end

        def sid
          resource.sid
        end

        def insync?(is)
          if cluster?
            is.to_s == should.to_s
          else
            Puppet.warning "#{resource}: #{name} has no effect on non clustered service."
            true
          end
        end

        def on_apply
          if cluster?
            provider.send("apply_#{self.class.name}", value)
          else
            Puppet.warning "#{resource}: #{name} has no effect on non clustered service."
          end
        end
      end
    end

    module ClassMethods
      def translate_to_resource(raw_resource)
        sid = raw_resource['SID']
        if cluster?(sid)
          value = raw_resource.column_data(column_name)
          value.empty? ? nil : value
        else
          nil
        end
      end

      def column_name(name = nil)
        if name
          @column_name = name
        else
          @column_name
        end
      end
    end
  end
end
