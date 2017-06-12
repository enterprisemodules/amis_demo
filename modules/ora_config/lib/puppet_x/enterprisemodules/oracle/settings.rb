# Docs
module Puppet_X
  module EnterpriseModules
    module Oracle
      module Settings
        # TODO: refacter DEFAULT_FILE
        DEFAULT_FILE = '/etc/ora_setting.yaml'.freeze

        ASM_REGXP       = /^(\+ASM|default_asm)\d*$/
        MGMT_REGXP      = /^\-MGMTDB\d*$/
        NON_ASM_REGXP   = /^(?:(?!(\+ASM|-MGMTDB|default_asm)\d*).)*$/

        def config_file
          Pathname.new(DEFAULT_FILE).expand_path
        end

        def self.included(parent)
          parent.extend(Settings)
        end

        def configuration_for(key)
          unless configuration.keys.include?(key)
            fail "No configuration found for #{key}."
          end
          configuration[key]
        end

        def configuration_value_for(sid, value, default_value = '')
          configuration_for(sid).fetch(value) { default_value }
        end

        def configuration
          if @configuration.nil? || @configuration == {}
            @configuration = read_from_yaml
          else
            @configuration
          end
        end

        def read_from_yaml
          if File.exist?(config_file)
            open(config_file) { |f| YAML.load(f) }
          else
            {}
          end
        end

        def asm_sid?(sid)
          sid =~ ASM_REGXP
        end

        def asm_sids
          registered_sids.select { |sid| asm_sid?(sid) }
        end

        def mgmt_sid?(sid)
          sid =~ MGMT_REGXP
        end

        def mgmt_sids
          registered_sids.select { |sid| mgmt_sid?(sid) }
        end

        def database_sid?(sid)
          sid =~ NON_ASM_REGXP
        end

        def database_sids
          registered_sids.select { |sid| database_sid?(sid) }
        end

        def valid_sid?(sid)
          registered_sids.include?(sid)
        end

        def valid_asm_sid?(sid)
          asm_sids.include?(sid)
        end

        def valid_database_sid(sid)
          database_sids.include?(sid)
        end

        def registered_sids
          configuration.keys
        end

        # Is the SID a local ruinning sid
        def remote_sid?(sid)
          connect_string = configuration_value_for(sid, 'connect_string')
          connect_string != '' || connect_string.include?(Facter.value('hostname'))
        end

        def local_pdb?(sid)
          pdb = configuration_value_for(sid, 'pluggable')
          connect_string = configuration_value_for(sid, 'connect_string')
          pdb && connect_string.include?(Facter.value('hostname'))
        end

        def container_db?(sid)
          configuration_value_for(sid, 'cdb')
        end

        def normal_db?(sid)
          !configuration_value_for(sid, 'pluggable') && !configuration_value_for(sid, 'cdb')
        end

        def running_sids
          running_database_sids + running_asm_sids + running_mgmt_sids
        end

        def running_database_sids
          database_sids.select do |sid|
            `pgrep -f "^(ora|xe)_pmon_#{sid}$"` != '' || remote_sid?(sid) || local_pdb?(sid)
          end
        end

        # Array of normal database that are running
        # Might not be needed after all, we'll see
        def running_normal_database_sids
          running_database_sids.select do |sid|
            `pgrep -f "^(ora|xe)_pmon_#{sid}$"` != '' && normal_db?(sid)
          end
        end

        # Array of multitenant database that are running
        # Might not be needed after all, we'll see
        def running_mt_database_sids
          running_database_sids.select do |sid|
            container_db?(sid) || local_pdb?(sid)
          end
        end

        def running_asm_sids
          asm_sids.select do |sid|
            `pgrep -f ^asm_pmon_\\\\#{sid}$` != '' || remote_sid?(sid)
          end
        end

        def running_mgmt_sids
          mgmt_sids.select do |sid|
            `pgrep -f ^mdb_pmon_\\\\#{sid}$` != '' || remote_sid?(sid)
          end
        end

        def default_sids
          ::Hash[configuration.select { |_sid, hash| hash['default'] == true }].keys
        end

        def num_default_database_sids
          database_sids.select { |sid| default_sids.include? sid }.size
        end

        def num_default_asm_sids
          database_sids.select { |sid| default_sids.include? sid }.size
        end

        def default_database_sid
          database_sids.select { |sid| default_sids.include? sid }.first
        end

        def default_asm_sid
          asm_sids.select { |sid| default_sids.include? sid }.first
        end
      end
    end
  end
end
