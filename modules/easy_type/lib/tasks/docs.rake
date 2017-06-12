require_relative('../easy_type/docs')

desc 'Create Markdown docs for all content'
task :docs => ['docs:puppet', 'docs:types']

namespace :docs do
  desc 'Create Markdown docs for Puppet defined types and classes'
  task :puppet do
    all_classes = Dir.glob('documentation/source/*.md').collect { |f| File.basename(f,'.md')}
    all_classes.each do |t|
      File.write("./documentation/#{t}.md", generate_puppet_doc(t))
    end
  end
  desc 'Create Markdown docs for custom types'
  task :types do
    include EasyType::Docs::ClassMethods
    all_types = Dir.glob('lib/puppet/type/*.rb').collect { |f| File.basename(f).split('.').first }
    all_types.each  do |t|
      File.write("./documentation/#{t}.md", generate_type_doc(t))
    end
  end
end

def generate_type_doc(type)
  STDERR.puts "Generating doc for #{type}..."
  type_name = type.capitalize
  $LOAD_PATH.unshift(File.expand_path(File.dirname(File.dirname(__FILE__))))
  $LOAD_PATH.unshift("#{FileUtils.pwd}/lib")
  require_relative('../easy_type/docs')
  require "puppet/type/#{type}.rb"
  type_class = Puppet::Type.const_get(type_name)
  type_class.extend(EasyType::Docs)
  type_class.full_doc
end

def generate_puppet_doc(name)
  STDERR.puts "Generating doc for #{name}..."
  require_relative '../easy_type/doc_simulator'
  doc = EasyType::DocSimulator.new(@module_name, name)
  doc.full_doc
end
