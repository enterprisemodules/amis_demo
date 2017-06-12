require 'easy_type/encryption'

module EasyType
  #
  # YamlPorperty get's its value from the yaml data based on the name of the property
  #
  #
  module EncryptedYamlProperty
    def self.included(parent)
      #
      # We use send here because in ruby 1.8.7, include is a private
      # method. In ruby 1.9 this has become public.
      # TODO: When we lose support for ruby 1.8.7 change this to more standard
      #
      parent.send(:include, EncryptedProperty)
      parent.send(:include, Encryption)
    end

    def on_apply
      resource.current_config[name.to_s] = encrypt(value)
    end

    def current_value
      decrypted_value(is)
    end

    def is
      resource.current_config.fetch(name.to_s) { '' }
    end
  end
end
