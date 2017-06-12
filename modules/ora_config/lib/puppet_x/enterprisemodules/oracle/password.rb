require 'digest/sha1'
require 'puppet_x/enterprisemodules/oracle/information'
# rubocop: disable Style/ClassAndModuleCamelCase
module Puppet_X
  module EnterpriseModules
    module Oracle
      # docs
      module Password
        include Puppet_X::EnterpriseModules::Oracle::Information


        def get_current_password_information
          #
          # A hashed password has the format S:61B19096E12ADE8417B04A50D801B1102E72E0C484C759ED057F601357A1;rest
          # we need the part after the double colon but before the semi colon
          #
          s_part = current_hashed_password.split(';').select { |e| e.include?('S:') }.first
          if s_part
            hash           = s_part.split(':').last
            @password_hash = hash[0, 40]
            @salt          = hash[40, 20]
          else
            @password_hash = nil
            @salt          = nil
          end
        end

        def is_password_hash
          get_current_password_information unless @password_hash
          @password_hash
        end

        def should_password_hash
          if @salt
            get_current_password_information
            sha1 = Digest::SHA1.new
            sha1.update(value)
            sha1.update(salt_string)
            sha1.hexdigest.upcase
          else
            ''
          end
        end

        def current_hashed_password
          options = { :sid => sid_from_resource }
          password_info = case oracle_major_version(sid_from_resource)
                          when 10
                            sql "SELECT password FROM dba_users WHERE name='#{resource[:username]}'", options
                          when 11, 12
                            sql "SELECT spare4 as password FROM sys.user$ WHERE name='#{resource[:username]}'", options
                          else
                            fail 'unsupported Oracle version'
                          end
          password_info.first['PASSWORD']
        end


        def salt_string
          @salt.scan(/../).map { |x| x.hex.chr }.join
        end

      end
    end
  end
end
