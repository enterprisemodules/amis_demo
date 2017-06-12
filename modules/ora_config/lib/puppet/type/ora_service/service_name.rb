newparam(:service_name) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The service name.

    The service name **MUST** be a full qualified name. e.g. a name containing a domain. For example:

        ora_service{'mydb.mydomain.com@sid':
          ensure => 'present',
        }

  EOD

  validate do |value|
    fail 'service name must be a full qualified name,including a domain name' unless value.include?('.')
  end

  isnamevar

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('NAME').upcase
  end
end
