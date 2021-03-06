require 'tempfile'
require 'fileutils'
require 'puppet_x/enterprisemodules/oracle/ora_tab'
require 'puppet_x/enterprisemodules/oracle/sqlplus_command'
# rubocop: disable Style/ClassAndModuleCamelCase

module Puppet_X
  module EnterpriseModules
    module Oracle
      # docs
      class Sql
        attr_reader :sid, :username, :password, :os_user, :timeout

        def initialize(options = {})
          @command     = SqlplusCommand.new(options)
          @sid         = @command.sid
          @os_user     = @command.os_user
          @username    = @command.username
          @password    = @command.password
          @timeout     = @command.timeout
        end

        def execute(command)
          create_output_file
          @command.execute_sql_command(command, @output_file.path)
        end

        private

        def create_output_file
          @output_file = Tempfile.new(['output', '.csv'])
          @output_file.close
          FileUtils.chown(@os_user, nil, @output_file.path)
          FileUtils.chmod(0o600, @output_file.path)
        end
      end
    end
  end
end
