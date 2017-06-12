newproperty(:source) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access

  desc <<-EOD
  A file describing the content of the package.

  Because puppet uses the contents of this file to descide if something needs to be done, the
  contents of this file must be very strict to the way Oracle stores the package source in the database.

  To decide if a change must be done, Puppet will fetch the trigger definition from the database and the contents
  of the source. For both it will remove all:

  - comments
  - empty lines
  - spaces
  - newlines
  - quotes

  and do a comparisson.

  EOD

  to_translate_to_resource do |_raw_resource|
    'content-in-database'
  end

  #
  # Here we have the content and do the compare.
  #
  def insync?(_is)
    if current_content == required_content
      Puppet.warning "#{path}: package #{resource.owner}.#{resource.name} up-to-date, but contains #{compilation_errors} error(s)." \
        if contains_errors? && resource.report_errors
      true
    else
      current_content_file = Tempfile.new('ora_package')
      current_content_file.write(current_content)
      current_content_file.close
      required_content_file = Tempfile.new('ora_package')
      required_content_file.write(required_content)
      required_content_file.close
      binary_diff = `diff #{required_content_file.path} #{current_content_file.path}`
      Puppet.info "#{path}: Binary difference is:\n#{binary_diff}"
      false
    end
  end

  def change_to_s(currentvalue, _newvalue)
    if currentvalue == :absent
      'created package definition and content'
    else
      'changed to new package definition and content'
    end
  end

  def current_content
    @current_content ||= process_content(sql(template('ora_config/ora_package/package_definition.sql.erb', binding), :sid => resource.sid, :parse => false))
  end

  def required_content
    @required_content ||= process_content(File.read(value))
  end

  def process_content(content)
    new_content = content.gsub(/CONTENT\s*\n-*\s*\n/, '') \
                         .gsub(/--.*\n/, '') \
                         .gsub(%r{^/\s*$}, '') \
                         .gsub(/\s|\s|"|'/, '') \
                         .delete("\n").upcase
    if resource[:editionable] == :false
      new_content.gsub(/(?:non)?editionable/i, '')
    else
      new_content
    end
  end

  def compilation_errors
    results = sql template('ora_config/ora_package/package_errors.sql.erb', binding), :sid => resource.sid
    results.first['ERRORS'].to_i
  end

  def contains_errors?
    compilation_errors > 0
  end
end
