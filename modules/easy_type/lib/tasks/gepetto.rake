begin
  require_relative '../easy_type/lib/compressor'

  desc 'Create source readable by Geppetto'
  task 'geppetto' do
    files = Dir.glob('lib/puppet/type/*.rb')
    raise ArgumentError unless files
    %w(geppetto geppetto/puppet geppetto/puppet/type).each do |dir|
      Dir.mkdir(dir) unless Dir.exist?(dir)
    end
    files.each do |file|
      type_name = File.basename(file).split('.')[0]
      content = Compressor.new(type_name).compress
      File.write("geppetto/puppet/type/#{type_name}.rb", content)
    end
  end

rescue LoadError, NoMethodError

end
