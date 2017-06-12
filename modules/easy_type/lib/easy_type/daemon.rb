# encoding: UTF-8
require 'open3'
require 'timeout'
# rubocop: disable Style/SignalException
# rubocop: disable Metrics/AbcSize

module EasyType
  #
  # The EasyType:Daemon class, allows you to easy write a daemon for your application utility.
  # To get it working, subclass from
  #
  # rubocop:disable ClassVars
  class Daemon
    OLD_SUCCESS_SYNC_STRING = /~~~~COMMAND SUCCESFULL~~~~/
    SUCCESS_SYNC_STRING     = /~~~~COMMAND SUCCESSFUL~~~~/
    FAILED_SYNC_STRING      = /~~~~COMMAND FAILED~~~~/
    TIMEOUT = 60 # wait 60 seconds as default

    @@daemons = {}
    #
    # Check if a daemon for this identity is running. Use this to determin if you need to start the daemon
    #
    def self.run(identity)
      daemon_for(identity) if daemonized?(identity)
    end

    ##
    # Initialize a command daemon. In the command daemon, the specified command is run in a daemon process.
    # The specified command must readiths commands from stdi and output any results from stdout.
    # A daemon proces must be identified by an identifier string. If you want to run multiple daemon processes,
    # say for connecting to an other, you can use a different name.
    #
    # If you want to run the daemon as an other user, you can specify a user name, the process will run under.
    # This must be an existing user.
    #
    # Checkout sync on how to sync the output. You can specify a timeout value to have the daemon read's
    # timed out if it dosen't get an expected answer within that time.
    #
    #
    #
    def initialize(identifier, command, user, filters = [], errors = [])
      return @@daemons[identifier] if @@daemons[identifier]
      initialize_daemon(user, command, filters)
      @identifier = identifier
      @@daemons[identifier] = self
      @errors = Regexp.union(errors << FAILED_SYNC_STRING)
    end

    #
    # Pass a command to the daemon to execute
    #
    def execute_command(command)
      @stdin.puts command
    end

    #
    # Wait for the daemon process to return a valid sync string. YIf your command passed
    # ,return the string '~~~~COMMAND SUCCESFULL~~~~'. If it failed, return the string '~~~~COMMAND FAILED~~~~'
    #
    #
    def sync(timeout = TIMEOUT, &proc)
      @output = ''
      loop do
        line = timed_readline(timeout)
        @output << line.gsub(@filter, '*** Filtered ***')
        break if line =~ SUCCESS_SYNC_STRING || line =~ OLD_SUCCESS_SYNC_STRING
        fail "command in deamon failed.\n #{@output}" if line =~ @errors
        yield(line) if proc
      end
      Puppet.debug @output.to_s
      @output
    end

    private

    def timed_readline(timeout)
      Timeout.timeout(timeout) do
        @stdout.readline
      end
    rescue Timeout::Error
      Puppet.err @output
      fail 'timeout on reading expected output from daemon process.'
    end

    # @nodoc
    def self.daemonized?(identity)
      !daemon_for(identity).nil?
    end
    private_class_method :daemonized?

    # @nodoc
    def self.daemon_for(identity)
      @@daemons[identity]
    end
    private_class_method :daemon_for

    # @nodoc
    def initialize_daemon(user, command, filters = [])
      @filter = Regexp.union(filters)
      if user
        @stdin, @stdout, @stderr = Open3.popen3("su - #{user}")
        execute_command(command)
      else
        @stdin, @stdout, @stderr = Open3.popen3(command)
      end
      @error_reader = Thread.new do
        loop do
          line = @stderr.readline.gsub(@filter, '*** Filtered ***')
          Puppet.debug line
        end
      end
      at_exit do
        Thread.kill(@error_reader)
        Puppet.debug "Quiting daemon #{@identifier}..."
        @stdin.close
        @stdout.close
        @stderr.close
      end
    end
  end
  # rubocop:enable ClassVars
end
