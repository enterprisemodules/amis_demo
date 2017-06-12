require 'puppet_x/enterprisemodules/oracle/settings'
# rubocop: disable Style/ClassAndModuleCamelCase
module Puppet_X
  module EnterpriseModules
    module Oracle
      # docs
      class Command
        include Settings

        DEFAULT_TIMEOUT = 300 # 5 minutes

        VALID_OPTIONS = [
          :sid,
          :os_user,
          :password,
          :timeout,
          :username
        ].freeze

        attr_reader(*VALID_OPTIONS)

        def initialize(command, options, valid_options = VALID_OPTIONS)
          @valid_options = valid_options
          check_options(options)
          @command  = command
          @password = options[:password] # may be empty
          @timeout  = options.fetch(:timeout) { DEFAULT_TIMEOUT }
          @sid      = options.fetch(:sid) { raise ArgumentError, 'you need to specify a sid for oracle access' }
          @os_user  = options.fetch(:os_user) { configuration_value_for(@sid, 'os_user') }
          @username = options.fetch(:username) { nil }
        end

        def command_string(arguments = '')
          "su - #{@os_user} -c \"cd #{working_dir}; export ORACLE_SID=#{@sid};export ORAENV_ASK=NO;. oraenv; #{@command} #{arguments}\""
        end

        def execute(arguments)
          options = { :failonfail => true, :combine => true }
          value = ''
          within_time(@timeout) do
            Puppet.debug "Executing #{@command} command: #{arguments} on #{@sid} as #{os_user}, connected as #{username}"
            value = Puppet::Util::Execution.execute(command_string(arguments), options)
          end
          value
        end

        protected

        def working_dir
          pwd = Dir.pwd
          unless writable_by_user(@os_user, pwd)
            Puppet.debug "Running Oracle command from a pwd that is not writable for os user #{os_user} therefore resetting pwd to '/tmp'"
            pwd = '/tmp'
          end
          pwd
        end

        private

        def writable_by_user(os_user, pwd)
          system "su - #{os_user} -c \"cd #{pwd};\" > /dev/null 2>&1"
        end

        def within_time(timeout)
          Puppet.debug "Using timeout #{timeout}"
          if timeout.zero?
            yield
          else
            Timeout.timeout(timeout) do
              yield
            end
          end
        end

        def check_options(options)
          options.each_key { |key| raise ArgumentError, "option #{key} invalid for #{@command}. Only #{@valid_options.join(', ')} are supported" unless @valid_options.include?(key) }
        end
      end
    end
  end
end
