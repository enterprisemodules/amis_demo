require 'pathname'
require 'puppet_x/enterprisemodules/classy_hash'
# rubocop: disable Style/ClassAndModuleCamelCase

module Puppet_X
  module EnterpriseModules
    module Oracle
      # docs
      module Schemas
        BOOLEAN   = [TrueClass, 'Yes', 'No', 'Y', 'N', 'y', 'n'].freeze
        SIZE      = lambda do |v|
          if v =~ /^(\d+\s?[K|k|M|m|G|g|T|t|P|p|E|e]?)|unlimited$/
            true
          else
            return 'valid size value'
          end
        end

        DISKGROUP_DISK = {
          'diskname' => String,
          'path'     => String
        }.freeze

        AUTOEXTEND = {
          'next'    => [:optional, SIZE],
          'maxsize' => [:optional, SIZE]
        }.freeze

        LOGFILEGROUP = {
          'file_name'   => [:optional, String],
          'reuse'       => [:optional, BOOLEAN],
          'size'        => [:optional, SIZE],
          'autoextend'  => [:optional, AUTOEXTEND],
          'group'       => [:optional, Integer]
        }.freeze

        DATAFILE = {
          'file_name'   => [:optional, String],
          'reuse'       => [:optional, BOOLEAN],
          'size'        => [:optional, SIZE],
          'autoextend'  => [:optional, AUTOEXTEND]
        }.freeze

        EXTENT_MANAGEMENT = {
          'type'         => lambda { |v| %w(local dictionary).include?(v.downcase) || 'local or dictonary' },
          'autoallocate' => [:optional, BOOLEAN],
          'uniform_size' => [:optional, SIZE]
        }.freeze

        TABLESPACE_TYPE = lambda { |v| %w(bigfile smallfile).include?(v.downcase) || 'bigfile or smallfile' }

        def validate_extent_management(value)
          if value
            with_hash(value) do
              type = value_for('type')
              if type.casecmp('dictionary').zero? && exists?('autoallocate')
                raise ArgumentError, 'extent management dictionary, incompatible with autoallocate'
              end
              if type.casecmp('dictionary').zero? && exists?('uniform_size')
                raise ArgumentError, 'extent management dictionary, incompatible with uniform_size'
              end
            end
          end
        end

        def file_specification(value)
          entry = []
          with_hash(value) do
            autoextend_value = value_for('autoextend')
            entry << "'#{value_for('file_name')}'" if value_for('file_name')
            entry << content_if('size')
            entry << key_if('reuse')
            entry << autoextend(autoextend_value).to_s if exists?('autoextend')
          end
          entry.join(' ')
        end

        def file_characteristics(value)
          entry = []
          with_hash(value) do
            entry << content_if('size')
            entry << key_if('reuse')
          end
          entry.join(' ')
        end

        def datafiles(value)
          value = [value] unless value.is_a?(Array) # values can be either a Hash or an Array
          value.collect do |v|
            entry = []
            with_hash(v) do
              entry << file_specification(v)
            end
            entry.compact.join(' ')
          end.compact.join(', ')
        end

        def autoextend(value)
          entry = ['autoextend on']
          with_hash(value) do
            entry << content_if('next')
            entry << content_if('maxsize')
          end
          entry.compact.join(' ')
        end

        def extent_management(value)
          return_value = []
          with_hash(value) do
            return_value << "extent management #{value_for('type')}"
            return_value << key_if('autoallocate')
            return_value << content_if('uniform_size')
          end
          return_value.compact.join(' ')
        end
      end
    end
  end
end
