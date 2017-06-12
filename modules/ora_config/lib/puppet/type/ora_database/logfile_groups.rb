# encoding: UTF-8
require 'puppet_x/enterprisemodules/oracle/schemas'
require 'puppet_x/enterprisemodules/extend_hash'
# rubocop: disable Style/ClassAndModuleCamelCase
# rubocop: disable Style/ClassAndModuleChildren
# rubocop: disable Metrics/MethodLength

newparam(:logfile_groups, :array_matching => :all) do
  # Docs
  class ::Puppet::Type::Ora_database::ParameterLogfile_groups
    include EasyType
    include Puppet_X::EnterpriseModules::Oracle::Schemas
    include Puppet_X::EnterpriseModules::ExtendHash

    desc <<-EOD
      Specify the logfile groups.

      Use this syntax to specify all attributes of the logfile groups. When you want
      use one log file per group and use group numbers starting from 1 up, you can
      use the easy implementation:

          ora_database{'dbname':
            ...
            logfile_groups => [
                {file_name => 'test1.log', size => '10M', reuse => true},
                {file_name => 'test2.log', size => '10M', reuse => true},
              ],
          }

      When you want to use more logfiles per loggroup and/or use specific log group
      numbers, you need to use the extended implementation:

          ora_database{'dbname':
            ...
            logfile_groups => [
                {group => 10, file_name => 'test10a.log', size => '10M', reuse => true},
                {group => 10, file_name => 'test10b.log', size => '10M', reuse => true},
                {group => 20, file_name => 'test20a.log', size => '10M', reuse => true},
                {group => 20, file_name => 'test20b.log', size => '10M', reuse => true},
              ],
          }


    EOD

    VALIDATION = Puppet_X::EnterpriseModules::Oracle::Schemas::LOGFILEGROUP

    def validate(value)
      value = [value] if value.is_a?(Hash) # ensure, it is an array
      value.each { |v| ClassyHash.validate_strict(v, VALIDATION) }
    end

    def value
      numbered_groups = @value.map { |e| e unless e['group'].nil? }.compact
      non_numbered_groups = @value - numbered_groups
      fail 'cannot mix numbered and non-numbered groups' if numbered_groups.any? && non_numbered_groups.any?
      command_segment = []
      if non_numbered_groups.any?
        non_numbered_groups.each_index do |index|
          group = index + 1
          entry = non_numbered_groups[index]
          command_segment << "group #{group} #{file_specification(entry)}"
        end
        "logfile #{command_segment.join(', ')}"
      elsif numbered_groups.any?
        group_numbers = numbered_groups.collect { |e| e['group'] }.uniq
        group_numbers.each do |group|
          files = numbered_groups.map { |e| e['file_name'] if e['group'] == group }.compact
          entry = numbered_groups.map { |e| e if e['group'] == group }.compact.first
          file_segments = files.collect { |f| "'#{f}'" }
          command_segment << if files.empty?
                               "group #{group} #{file_characteristics(entry)} "
                             elsif files.count == 1
                               "group #{group} #{file_segments.join(', ')} #{file_characteristics(entry)} "
                             else
                               "group #{group} (#{file_segments.join(', ')}) #{file_characteristics(entry)} "
                             end
        end
        "logfile #{command_segment.join(', ')}"
      else
        ''
      end
    end
  end
end
