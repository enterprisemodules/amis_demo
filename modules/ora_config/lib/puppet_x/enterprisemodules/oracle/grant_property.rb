module Puppet_X
  module EnterpriseModules
    module Oracle
      # Docs
      module GrantProperty
        def self.included(parent)
          parent.extend(ClassMethods)
        end

        def change_to_s(_from, _to)
          return_value = []
          return_value << "revoked the #{revoked_rights.join(',')} #{admin_option} right(s)" if revoked_rights.any?
          return_value << "granted the #{granted_rights.join(',')} #{admin_option} right(s)" if granted_rights.any?
          return_value.join(' and ')
        end

        # Every property needs to re"implement this
        def revoked_rights
          []
        end

        # Every property needs to re"implement this
        def granted_rights
          []
        end

        def current_rights
          rights_for_grantee(resource.grant_key, resource.sid)
        end

        def revoke(right)
          if resource.provider.container == :all
            "revoke #{right} from #{resource.grant_key} container = all"
          else
            "revoke #{right} from #{resource.grant_key}"
          end
        end

        def grant(rights)
          if resource.provider.container == :all
            "grant #{rights} to #{resource.grant_key} #{admin_option} container = all"
          else
            "grant #{rights} to #{resource.grant_key} #{admin_option}"
          end
        end

        def rights_for_grantee(user, sid)
          self.class.rights_for_grantee(user, sid)
        end

        def after_apply
          revoked_rights.each do |right|
            sql(revoke(right), :sid => resource.sid)
          end
          granted_rights.each do |right|
            sql(grant(right), :sid => resource.sid)
          end
        end

        def admin_option
          self.class.admin ? 'with admin option' : ''
        end


        # Docs
        module ClassMethods
          def translate_to_resource(raw_resource)
            @all_rights ||= privileges + granted_roles
            grantee     = raw_resource.column_data(grantee_column).upcase
            sid         = raw_resource.column_data('SID')
            rights_for_grantee(grantee, sid)
          end

          #
          # Proxy to the type class. So we only have to specify it once for all
          # grant related properties in a type
          #
          def grantee_column
            self.to_s.split('::')[0..-2].reduce(Kernel) {|root, new| root.const_get(new)}.grantee_column
          end

          def rights_for_grantee(grantee, sid)
            @all_rights.select { |r| r['GRANTEE'] == grantee && r['SID'] == sid }.collect { |u| u['PRIVILEGE'] }
          end

          def admin_option
            admin ? 'YES' : 'NO'
          end

          def privileges
            sql_on_all_database_sids "select distinct grantee, privilege from dba_sys_privs where admin_option = '#{admin_option}'"
          end

          def granted_roles
            sql_on_all_database_sids "select distinct grantee, granted_role as privilege from dba_role_privs where admin_option = '#{admin_option}'"
          end
        end
      end
    end
  end
end
