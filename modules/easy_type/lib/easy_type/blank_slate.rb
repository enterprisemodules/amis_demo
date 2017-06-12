# encoding: UTF-8
# @nodoc
class BlankSlate
  ruby_18 do
    REQUIRED_METHODS = %w(instance_eval object_id __send__ __id__).freeze
  end
  ruby_19 do
    REQUIRED_METHODS = [
      :instance_eval,
      :object_id,
      :__send__,
      :__id__,
      :debugger,
      :puts,
      :extend
    ].freeze
  end
  instance_methods.each do |m|
    undef_method m unless REQUIRED_METHODS.include?(m)
  end

  attr_accessor :entries, :type, :results
  TYPES = [:main, :before, :after].freeze

  def initialize
    @entries = {}
    @results = {}
    TYPES.each do |type|
      @results[type] = []
      @entries[type] ||= []
    end
  end

  def execute
    TYPES.each do |type|
      entries[type].each do |command_entry|
        results[type] << command_entry.execute
      end
    end
  end

  def eigenclass
    class << self
      self
    end
  end
end
