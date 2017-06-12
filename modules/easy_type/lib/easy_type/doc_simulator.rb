require_relative 'docs'
require 'puppet'

# docs
module EasyType
  ##
  #
  # This class simulates a Puppet type to create documentation based on the Puppet
  # documentation API for types.
  class DocSimulator
    include Puppet::Util::Docs
    include EasyType::Docs::ClassMethods
    include EasyType::Docs

    # docs
    class AttributeSimulator
      attr_reader :name, :type_name, :doc

      def initialize(type_name, attribute_name)
        @name = attribute_name
        @type_name = type_name
        @doc = content_for(attribute_file)
      end

      def content_for(file_name)
        template = File.read(file_name)
        @doc = ERB.new(template, nil, '-').result(binding)
      end

      def source_dir
        './documentation/source'
      end

      def attribute_file
        if File.exist?(private_name)
          private_name
        elsif File.exist?(shared_name)
          shared_name
        else
          raise ArgumentError, "File for property #{name} of #{type_name} doesn't exist."
        end
      end

      def private_name
        "#{source_dir}/#{type_name}/#{name}.md"
      end

      def shared_name
        "#{source_dir}/shared/#{name}.md"
      end
    end

    attr_reader :name, :module_name, :attributes, :doc, :all_attribute_classes

    def initialize(module_name, name)
      @name = name
      @module_name = module_name
      file_name = "#{source_dir}/#{name}.md"
      template = File.read(file_name)
      @doc = ERB.new(template, nil, '-').result(binding)
      raise ArgumentError, "#{file_name} should contain attribute definitions" unless attributes
      @all_attribute_classes = @attributes.collect do |attribute|
        AttributeSimulator.new(name, attribute)
      end.flatten
    end

    def all_attributes_sorted
      @attributes.sort
    end

    def attrclass(attribute)
      all_attribute_classes.select { |c| c.name == attribute }.first
    end

    def include_attributes(attributes)
      @attributes = attributes
    end

    def source_dir
      './documentation/source'
    end
  end
end
