require 'tempfile'
require 'fileutils'
require 'puppet_x/enterprisemodules/oracle/sql'
require 'puppet_x/enterprisemodules/oracle/settings'
require 'puppet_x/enterprisemodules/oracle/information'

# rubocop: disable Style/ClassAndModuleCamelCase

module Puppet_X
  module EnterpriseModules
    module Oracle
      # Docs
      module Access
        include EasyType::Helpers
        include Settings

        def module_name
          'ora_config'
        end

        def self.included(parent)
          parent.extend(Access)
        end

        def for_version(hash)
          value = hash.collect do |version, query|
            [lambda { |sid| oracle_version?(sid, version) }, query]
          end
        end

        #
        # This is the reverse of Oracle's rawtohex
        # TODO: See if we can make this more efficient
        #
        def hex_to_raw(raw)
          raw.chars.each_slice(2).collect do |slice|
            txt = slice[0] + slice[1]
            txt.hex.chr
          end.join
        end

        #
        # Check if the oracle version of the specfied sid is equal to the
        # specified version.
        #
        def oracle_version?(sid, version)
          return true if version == :default
          oracle_major_version(sid) == version.to_s.to_i
        end

        ##
        #
        # Use this function to execute Oracle statements on all running databases.
        # This excludes asm database
        #
        # @param command [String] this is the commands to be given
        #
        #
        def sql_on_all_database_sids(command, parameters = {})
          sids = running_database_sids
          sql_on_sids(sids, command, parameters)
        end

        ##
        #
        # Use this function to execute Oracle statements on all running normal databases.
        # This excludes asm and multitenant databases
        #
        # @param command [String] this is the commands to be given
        #
        #
        def sql_on_all_normal_sids(command, parameters = {})
          sids = running_normal_database_sids
          sql_on_sids(sids, command, parameters)
        end

        ##
        #
        # Use this function to execute Oracle statements on all running multitenant databases.
        # This excludes asm and normal databases
        #
        # @param command [String] this is the commands to be given
        #
        #
        def sql_on_all_mt_sids(command, parameters = {})
          sids = running_mt_database_sids
          sql_on_sids(sids, command, parameters)
        end

        ##
        #
        # Use this function to execute Oracle statements on all running asm sids.
        #
        # @param command [String] this is the commands to be given
        #
        def sql_on_all_asm_sids(command, parameters = {})
          sids = running_asm_sids
          sql_on_sids(sids, command, parameters)
        end

        ##
        #
        # Use this function to execute Oracle statements on all running mgmtdb sids.
        #
        # @param command [String] this is the commands to be given
        #
        def sql_on_all_mgmt_sids(command, parameters = {})
          sids = running_mgmt_sids
          sql_on_sids(sids, command, parameters)
        end

        ##
        #
        # Use this function to execute Oracle statements on all running sid.
        # This includes asm database
        #
        # @param command [String] this is the commands to be given
        #
        #
        def sql_on_all_sids(command, parameters = {})
          sids = running_sids
          sql_on_sids(sids, command, parameters)
        end

        #
        # Run the sql commmand on all specified sids. If the sql is a String,
        # The string will be used as the sql statement.
        #
        # The command, can also be an array. In that case, every pair contains
        # a landa followed by an sql sattement e.g
        #
        #  [
        #      lamda { a check},         'select * from tab',
        #      lamda { an other  check}, 'select * from users',
        #  ]
        #
        # The check will be executed on every sid. You can use this for example
        # to use different statements on different versions of oracle
        #
        # @param sids [Array] Array of sids to run the command on
        # @param command [String] Sql statement to run on all sids
        #
        # or
        # @param command [Array] Array of lambda's and sql statements.
        #
        # @return [Array] The returned results
        #
        def sql_on_sids(sids, command, parameters = {})
          results = []
          sids.each do |sid|
            statement = if versioned_statement?(command)
                          select_statement(command, sid)
                        else
                          command
                        end
            Puppet.debug "executing #{statement} on #{sid}"
            results += sql(statement, { :sid => sid }.merge(parameters))
          end
          results
        end

        # @private
        #
        # Returns the first valid sql statement in the versioned command
        #
        def select_statement(versioned_command, sid)
          versioned_command.each do |version_proc, statement|
            return statement if version_proc.call(sid)
          end
          fail 'no valid version found'
        end

        # @private
        def versioned_statement?(command)
          command.is_a?(::Array)
        end

        ##
        #
        # Use this function to execute Oracle statements
        #
        # @param command [String] this is the commands to be given
        #
        #
        def sql(command, options = {})
          options[:timeout] = self[:timeout] if timeout_specified
          parse = options.delete(:parse) { true }
          @sql = Sql.new(options)
          results = @sql.execute(command)
          if parse
            sid = @sql.sid
            add_sid_to(convert_csv_data_to_hash(results, [], :col_sep => ',', :converters => lambda { |f| f ? f.strip : nil }), sid)
          else
            results
          end
        end

        def add_sid_to(elements, sid)
          elements.collect do |e|
            e['SID'] = sid
            e
          end
        end

        # This is a little hack to get a specified timeout value
        def timeout_specified
          to_hash.fetch(:timeout) { nil } if respond_to?(:to_hash)
        end

        def sid_from_resource
          sid_from(resource)
        end

        def ora_autorequire(type, property)
          autorequire(type) do
            if property.is_a?(Array)
              property.collect { |p| resource_list_for(p) }.flatten
            else
              resource_list_for(property)
            end
          end
        end

        def resource_list_for(property)
          value = property.is_a?(Proc) ? instance_exec(&property) : send(property)
          current_sid = self[:sid]
          if value.nil? || value.empty?
            nil
          elsif value.is_a?(::Array)
            if current_sid
              value.collect { |element| "#{element}@#{current_sid}" }.flatten
            else
              value
            end
          else
            current_sid ? "#{value}@#{current_sid}" : value
          end
        end

        def sid_from(source)
          source.sid.nil? ? default_database_sid : source.sid
        end
      end
    end
  end
end
