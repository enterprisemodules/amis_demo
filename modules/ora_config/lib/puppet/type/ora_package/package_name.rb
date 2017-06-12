require 'puppet_x/enterprisemodules/oracle/mungers'

newparam(:package_name) do
  include EasyType
  include EasyType::Mungers::Upcase
  include EasyType::Validators::Name

  desc <<-EOD
    The name of the PL/SQL package you want to manage. The package name  is the second part of the
    title.

        ora_package { 'owner.package_name@sid':
          ...
        }

  EOD

  isnamevar
end
