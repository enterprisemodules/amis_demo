require 'puppet_x/enterprisemodules/oracle/settings'
# rubocop: disable Style/ClassAndModuleCamelCase
module Puppet_X
  module EnterpriseModules
    module Oracle
      # Docs
      class OraTab
        include Settings

        DEFAULT_CONTENT = <<-EOD.freeze
        #
        # This file is used by ORACLE utilities.  It is created by root.sh
        # and updated by either Database Configuration Assistant while creating
        # a database or ASM Configuration Assistant while creating ASM instance.
        #
        # A colon, ':', is used as the field terminator.  A new line terminates
        # the entry.  Lines beginning with a pound sign, '#', are comments.
        #
        # Entries are of the form:
        #   $ORACLE_SID:$ORACLE_HOME:<N|Y>:
        #
        # The first and second fields are the system identifier and home
        # directory of the database respectively.  The third filed indicates
        # to the dbstart utility that the database should , "Y", or should not,
        # "N", be brought up at system boot time.
        #
        # Multiple entries with the same $ORACLE_SID are not allowed.
        #
        #
        EOD

        def initialize(file = default_file)
          fail "oratab #{file} not found. Probably Oracle not installed" unless File.exist?(file)
          @oratab = file
        end

        def add_new_entry(sid, home, start)
          write(append_new_entry(sid, home, start))
        end

        def ensure_entry(sid, home, start)
          add_new_entry(sid, home, start) unless entry_exists?(sid)
        end

        def remove_entry(sid, home, start)
          delete(entry(sid, home, start))
        end

        def append_new_entry(sid, home, start)
          "#{oratab_content}#{sid}:#{home}:#{start}\n"
        end

        def entry(sid, home, start)
          "#{sid}:#{home}:#{start}\n"
        end

        def write(content)
          File.open(default_file, 'w') { |f| f.write(content) }
        end

        def delete(content)
          input = File.readlines(default_file)
          File.open(default_file, 'w') { |f| input.each { |line| f.write(line) unless line.include? content } }
          nil
        end

        def entry_exists?(sid)
          entries.find { |x| x[:sid] == sid }
        end

        def entry_autostart?(sid)
          entry_for(sid)[:start].chomp
        end

        def entry_for(sid)
          entries.select { |x| x[:sid] == sid }.first
        end

        def oratab_content
          File.open(default_file, &:read)
        rescue Errno::ENOENT
          DEFAULT_CONTENT
        end

        def entries
          values = []
          File.open(@oratab) do |oratab|
            oratab.each_line do |line|
              content = [:sid, :home, :start].zip(line.split(':'))
              values << ::Hash[content] unless comment?(line)
            end
          end
          values
        end

        private

        def comment?(line)
          line.start_with?('#', "\n")
        end

        def default_file
          case os
          when 'Linux' then '/etc/oratab'
          when 'SunOS' then '/var/opt/oracle/oratab'
          else fail 'unsupported OS'
          end
        end

        def os
          Facter.value(:kernel)
        end
      end
    end
  end
end
