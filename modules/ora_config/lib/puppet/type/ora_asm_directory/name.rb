require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  include Puppet_X::EnterpriseModules::Oracle::Mungers::LeaveSidRestToUppercase

  desc <<-EOD
    The name of the ora_asm_directory including SID.

        ora_asm_directory { '+DATA/DIR/SUBDIR@+ASM1':
          ...
        }

    The SID is optional. When you don't specify an SID, Puppet will take the ASM instance from
    ora_setting with property `default` set to true and use that as the SID. We recomend you to **always** use a full qualified
    name (e.g. a name including the SID) or not do it at all.

  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    sid = raw_resource.column_data('SID')
    directory_name = raw_resource.column_data('PATH').upcase
    "#{directory_name}@#{sid}"
  end
end
