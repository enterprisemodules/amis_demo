$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../../../../../easy_type/lib')
begin
  require 'easy_type/template'
rescue LoadError
  raise 'BAM module requires easy_type for templating'
end
#
# Allows you to use a puppet ural as a template. For example:
#
# file {'//testdata':
#   content => url_template('puppet:///modules/my_module/template.erb')
# }
#
Puppet::Functions.create_function('url_template', Puppet::Functions::InternalFunction) do
  dispatch :url_template do
    scope_param
    param 'String', :template_url
  end

  def url_template(scope, template_url)
    extend EasyType::Template
    scope_binding = scope.send(:binding)
    template(template_url, scope_binding)
  end
end
