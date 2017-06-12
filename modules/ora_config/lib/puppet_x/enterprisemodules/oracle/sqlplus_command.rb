require 'puppet_x/enterprisemodules/oracle/command'
require 'puppet_x/enterprisemodules/oracle/settings'
require 'easy_type'
require 'easy_type/encryption'
# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassVars

module Puppet_X
  module EnterpriseModules
    module Oracle
      # Docs
      class SqlplusCommand < Puppet_X::EnterpriseModules::Oracle::Command
        include EasyType::Template
        include Settings
        include EasyType::Encryption

        @@created_files ||= []

        VALID_OPTIONS = [
          :sid,
          :os_user,
          :password,
          :timeout,
          :username,
          :failonsqlfail, # Don't fail if the sql fails
          :catch_errors,
          :catch_extra_errors
        ].freeze

        def initialize(options = {})
          @failonsqlfail = options.fetch(:failonsqlfail) { true }
          @catch_errors = options.fetch(:catch_errors) { /SP\d-\d{4}:.*/ }
          catch_extra_errors = options[:catch_extra_errors]
          @catch_errors = Regexp.union(@catch_errors, catch_extra_errors) if catch_extra_errors
          super('sqlplus -S /nolog ', options, VALID_OPTIONS)
        end

        def command_string(arguments = '')
          "su - #{@os_user} -c \"cd #{working_dir};export PERL5LIB=$(ls -d #{@oracle_home}/perl/lib/[0-9]*);export ORACLE_SID=#{@host_sid};export ORACLE_HOME=#{@oracle_home};export ORAENV_ASK=NO;. oraenv; #{@command} #{arguments}\""
        end

        def execute(arguments)
          options = { :failonfail => true, :combine => true }
          value = ''
          command = command_string(arguments)
          within_time(@timeout) do
            Puppet.debug "Executing #{@command} command: #{arguments} as user #{os_user}"
            value = Puppet::Util::Execution.execute(command, options)
          end
          output_file = Tempfile.new(['sql', '.log'])
          ObjectSpace.undefine_finalizer(output_file) # Don't delete the file
          output_file.write(value)
          output_file.close
          FileUtils.chown(@os_user, nil, output_file.path)
          FileUtils.chmod(0o600, output_file.path)
          FileUtils.chown(@os_user, nil, output_file.path)
          FileUtils.chmod(0o600, output_file.path)
          path = output_file.path
          @@created_files << path
          Puppet.debug "SQL output saved to #{output_file.path}"
          scan_for_errors(value) if @failonsqlfail
          value
        end

        def execute_sql_command(command, output_file)
          #
          # Set all values based on settings
          #
          sys_username           = configuration_value_for(@sid,'user')
          encrypted_sys_password = configuration_value_for(@sid,'password')
          sys_password           = sys_password.nil? || sys_password.empty? ? '' : decrypted_value(encrypted_sys_password)
          @oracle_home           = configuration_value_for(@sid, 'oracle_home')
          settings_cdb           = configuration_value_for(@sid, 'cdb')
          @syspriv               = configuration_value_for(@sid, 'syspriv')
          @contained_by          = configuration_value_for(@sid, 'contained_by')
          if @contained_by.nil? ||  @contained_by.empty?
            @host_sid = @sid
          else
            @host_sid = @contained_by
          end
          #
          # Validate values
          #
          if sys_password.include? '@'
            fail "Invalid password specified for user #{sys_username}"
          end
          if configuration_value_for(@sid, 'connect_string').empty?
            @connect_string = ''
          else
            @connect_string = '@' + configuration_value_for(@sid, 'connect_string')
          end
          #
          # Do the stuff
          #
          Puppet.debug "Executing sql statement :\n #{command}"
          script = command_file(template('ora_config/ora_config/execute.sql.erb', binding))
          if username
            Puppet.debug "Connecting to oracle_sid #{@sid} with connect_string \"#{@connect_string}\" as user #{username} and privilege #{@syspriv}"
          else
            Puppet.debug "Connecting to oracle_sid #{@sid} with connect_string \"#{@connect_string}\" as user #{sys_username} and privilege #{@syspriv}"
          end
          execute "@#{script}"
          File.read(output_file)
        end

        private

        def scan_for_errors(string)
          if string.scan(@catch_errors).any?
            fail "error in sql statement processing\n #{string}"
          end
        end

        def command_file(content)
          command_file = Tempfile.new(['command', '.sql'])
          ObjectSpace.undefine_finalizer(command_file) # Don't delete the file
          command_file.write(content)
          command_file.close
          FileUtils.chown(@os_user, nil, command_file.path)
          FileUtils.chmod(0o600, command_file.path)
          FileUtils.chown(@os_user, nil, command_file.path)
          FileUtils.chmod(0o600, command_file.path)
          path = command_file.path
          @@created_files << path
          path
        end

        at_exit do
          #
          # If environment variable ORA_CONFIG_KEEP is set to yes,
          # we won't remove the files else we will.
          #
          unless ENV['ORA_CONFIG_KEEP'].to_s.casecmp('yes').zero?
            @@created_files.each { |cmd_file| FileUtils.rm(cmd_file) }
          end
        end
      end
    end
  end
end
