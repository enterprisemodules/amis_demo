# encoding: UTF-8
require 'easy_type/preamble'
require 'easy_type/setup'
require 'easy_type/yaml_type'
require 'easy_type/yaml_property'
require 'easy_type/encrypted_property'
require 'easy_type/encrypted_yaml_property'
require 'easy_type/parameter'
require 'easy_type/type'
require 'easy_type/mungers'
require 'easy_type/validators'
require 'easy_type/syncers'
require 'easy_type/file_includer'
require 'easy_type/script_builder'
require 'easy_type/group'
require 'easy_type/template'
require 'easy_type/helpers'
require 'easy_type/daemon'
require 'easy_type/provider'

# @nodoc
module EasyType
  def self.included(parent)
    parent.send(:include, EasyType::Helpers)
    parent.send(:include, EasyType::FileIncluder)
    parent.send(:include, EasyType::Template)
    parent.send(:include, EasyType::Type) if parent.ancestors.include?(Puppet::Type)
    parent.send(:include, EasyType::Parameter) if parent.ancestors.include?(Puppet::Parameter)
  end
end
