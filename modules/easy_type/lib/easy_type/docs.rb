require 'fileutils'

module EasyType
  #
  # generate the markdown docs
  #
  module Docs
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    def attribute_summary
      attributes = all_attributes_sorted.collect { |a| [reference_for(a), attribute_summary_for(a)] }
      doctable(['Attribute Name', 'Short Description'], Hash[attributes])
    end

    def all_attribute_classes
      all_attributes_sorted.collect { |a| attrclass(a) }
    end

    def reference_for(attribute)
      "[#{attribute}](##{name}_#{attribute})"
    end

    def attribute_summary_for(attribute)
      attrclass(attribute).doc.scan(/^((.*?\.)|(.*?)\n)\s/).flatten.first
    end

    def type_summary
      doc.scan(/^((.*?\.)|(.*?)\n)\s/).flatten.first
    end

    ##
    #
    # Get a sorted list of all attributes
    #
    def all_attributes_sorted
      (properties.collect(&:name) + parameters).sort
    end

    ##
    #
    # Get a sorted list of properties
    #
    def sorted_parameters
      parameters.sort { |a, b| a.to_s <=> b.to_s }
    end

    ##
    #
    # Get a sorted list of documented parameters that are not name parameters
    #
    def documented_parameter_classes
      sorted_parameters.flat_map do |sname|
        parameter = attrclass(sname)
        if parameter.isnamevar? || parameter.nodoc
          []
        else
          parameter
        end
      end
    end

    ##
    #
    # Get a sorted list of documented parameters
    #
    def name_parameter_classes
      parameters.flat_map do |sname|
        parameter = attrclass(sname)
        #
        # We filter out the name variable. It doesn't really help in documenting
        #
        if parameter.isnamevar? && !parameter.nodoc && parameter.name != :name
          parameter
        else
          []
        end
      end
    end

    ##
    #
    # Get a sorted list of properties
    #
    def sorted_properties
      validproperties.sort { |a, b| a.to_s <=> b.to_s }
    end

    ##
    #
    # Get a sorted list of documented properties
    #
    def documented_properties
      sorted_properties.reject do |sname|
        property = propertybyname(sname)
        property.nodoc
      end
    end

    ##
    #
    # Get a sorted list of documented parameter classes
    #
    def documented_property_classes
      documented_properties.collect { |name| propertybyname(name) }
    end

    ##
    #
    # Create the full documentation including type description and parameter
    # and property descriptions
    #
    def full_doc
      template = File.read(type_template)
      ERB.new(template, nil, '-').result(binding)
    end

    ##
    #
    # Return the first template directory you can find on the path
    #
    def template_dir
      module_template_dir || system_template_dir
    end

    ##
    #
    # Return the content of the type template
    #
    def type_template
      file_name = 'type_doc.md.erb'
      if File.exist?("#{module_template_dir}/#{file_name}")
        "#{module_template_dir}/#{file_name}"
      else
        "#{system_template_dir}/#{file_name}"
      end
    end

    def module_template_dir
      singleton_class.module_template_dir
    end

    def system_template_dir
      singleton_class.system_template_dir
    end

    # docs
    module ClassMethods
      def type_toc(types)
        $LOAD_PATH << "#{FileUtils.pwd}/lib"
        type_class = nil
        all_types = types.collect do |type|
          type_name = type.capitalize
          require "#{FileUtils.pwd}/lib/puppet/type/#{type}.rb"
          type_class = Puppet::Type.const_get(type_name)
          type_class.extend(EasyType::Docs)
          [reference_for(type).to_s, type_class.type_summary]
        end
        type_class.doctable(['Type Name', 'Short Description'], Hash[all_types])
      end

      def reference_for(type)
        "[#{type}](##{type.to_s.gsub(/[\_-]/, '')})"
      end

      def back_to(name)
        "[Back to overview of #{name}](#attributes)"
      end

      ##
      #
      # Construct the name of the template directory of the current module
      #
      def module_template_dir
        FileUtils.getwd + '/templates'
      end

      ##
      #
      # Return the easy_type template directory
      #
      def system_template_dir
        (Pathname.new(File.dirname(__FILE__)).parent.parent + 'templates').to_s
      end

      ##
      #
      # Create the full TOC for specified types
      #
      def toc(types)
        template = File.read(toc_template)
        ERB.new(template, nil, '-').result(binding)
      end

      ##
      #
      # Return the content of the TOC template
      #
      def toc_template
        file_name = 'toc.md.erb'
        if File.exist?("#{module_template_dir}/#{file_name}")
          "#{module_template_dir}/#{file_name}"
        else
          "#{system_template_dir}/#{file_name}"
        end
      end
    end
  end
end
