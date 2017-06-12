# rubocop: disable Style/ClassAndModuleCamelCase
module Puppet_X
  module EnterpriseModules
    module Oracle
      # docs
      module Directories
        def self.included(parent)
          parent.extend(Directories)
        end

        def remove_directories(_placeholder = nil, _options = {})
          remove_oracle_directory "#{oracle_base}/admin/#{name}"
          remove_oracle_directory "#{oracle_home}/dbs/init#{name}.ora"
          remove_oracle_directory "#{oracle_home}/dbs/spfile#{name}.ora"
          remove_oracle_directory "#{oracle_home}/dbs/hc_#{name}.dat"
          remove_oracle_directory "#{oracle_home}/dbs/lk#{name}.dat"
          remove_oracle_directory "#{oracle_home}/dbs/orapw#{name}.ora"
          remove_oracle_directory "#{oracle_base}/cfgtoolslog/dbca/#{name}"
        end

        def remove_oracle_directory(path)
          Puppet.debug "removing file/directory #{path}"
          FileUtils.rm_rf path
        end

        def create_directories(_placeholder = nil, _options = {})
          make_oracle_directory oracle_base
          make_oracle_directory oracle_home
          make_oracle_directory "#{oracle_home}/dbs"
          make_oracle_directory "#{oracle_base}/admin"
          make_oracle_directory "#{oracle_base}/cfgtoollogs"
          make_oracle_directory "#{oracle_base}/admin/#{name}"
          make_oracle_directory "#{oracle_base}/admin/#{name}/adump"
          make_oracle_directory "#{oracle_base}/admin/#{name}/ddump"
          make_oracle_directory "#{oracle_base}/admin/#{name}/dpdump"
          make_oracle_directory "#{oracle_base}/admin/#{name}/hdump"
          make_oracle_directory "#{oracle_base}/admin/#{name}/pfile"
          make_oracle_directory "#{oracle_base}/admin/#{name}/scripts"
          make_oracle_directory "#{oracle_base}/admin/#{name}/scripts/log"
          make_oracle_directory "#{oracle_base}/cfgtoollogs/dbca/#{name}"
        end

        def create_directory(path, _placeholder = nil, _options = {})
          make_oracle_directory path
        end

        def make_oracle_directory(path)
          Puppet.debug "creating directory #{path}"
          FileUtils.mkdir_p path
          owned_by_oracle(path)
        end

        def owned_by_oracle(*path)
          Puppet.debug "Setting ownership for #{path}"
          FileUtils.chmod 0o775, path
          FileUtils.chown oracle_user, install_group, path
        end
      end
    end
  end
end
