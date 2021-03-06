newparam(:instance) do
  include EasyType
  include EasyType::Validators::Name

  desc <<-EOD
    The instance name.
  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('INSTANCE_NAME')
  end

  def instance
    self[:instance].empty? ? self[:sid] : self[:instance]
  end
end

# rubocop: disable Style/ClassVars
def self.parse_instance_title
  @@instance_parser ||= lambda { |instance_name| instance_name.nil? ? '*' : instance_name[0..-2] }
end
