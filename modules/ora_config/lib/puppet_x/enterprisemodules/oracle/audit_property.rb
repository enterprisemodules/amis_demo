module Puppet_X
  module EnterpriseModules
    module Oracle
      # Docs
      module AuditProperty
        def self.included(parent)
          parent.extend(ClassMethods)
          parent.newvalues(:none,:by_access,:by_session)
        end


        def on_apply
          clause = case name.to_s
          when /.*_failure/
            'not successful'
          when /.*_success/
            'successful'
          else
            fail "#{name} is invalid here"
          end

          audit_type = name.to_s.split('_').first

          if value == :none
            sql("noaudit #{audit_type} on #{resource.owner}.#{resource.object_name} whenever #{clause}", :sid => resource.sid)
          else
            sql("audit #{audit_type} on #{resource.owner}.#{resource.object_name} #{value.to_s.gsub('_',' ')} whenever #{clause}", :sid => resource.sid)
          end
        end


        module ClassMethods

          def entry(element = nil)
            if element
              @entry = element
            else
              @entry
            end
          end

          def value_for(value)
            case value
            when 'A'
              'by_access'
            when 'S'
              'by_session'
            when '-'
              'none'
            else
              fail "#{value} is invalid here"
            end
          end

          def translate_to_resource(raw_resource)
             success, failure = raw_resource[entry].split('/')
            case name.to_s
            when /.*_failure/
              value_for(failure)
            when /.*_success/
              value_for(success)
            else
              fail "#{name} is invalid here"
            end
          end


        end
      end
    end
  end

end
