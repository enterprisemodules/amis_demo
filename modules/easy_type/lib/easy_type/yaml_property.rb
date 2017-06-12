# rubocop: disable Style/RedundantSelf
module EasyType
  #
  # YamlPorperty get's its value from the yaml data based on the name of the property
  #
  #
  module YamlProperty
    def self.included(parent)
      #
      # We use send here because in ruby 1.8.7, include is a private
      # method. In ruby 1.9 this has become public.
      # TODO: When we lose support for ruby 1.8.7 change this to more standard
      #
      parent.send(:include, EasyType)
      parent.extend(ClassMethods)
    end

    #
    # Class methods for yaml based properties
    #
    module ClassMethods
      def translate_to_resource(raw_resource)
        raw_resource[self.name]
      end
    end
  end
end
