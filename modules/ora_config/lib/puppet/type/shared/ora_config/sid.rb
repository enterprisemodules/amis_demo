newparam(:sid) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Settings

  desc <<-EOD
    SID to connect to.

    All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
    will use the database from the `/etc/ora_setting.yaml` with the property `default` set to `true`.
    We advise you to either use `@sid` in all your manifests or leave it empty everywhere.

  EOD

  isnamevar

  defaultto do
    sid = default_database_sid
    break nil if sid.nil?
    #
    # Some types don't end on a @
    #
    resource[:name] = if resource[:name][-1..-1] == '@'
                        resource[:name] + sid
                      else
                        resource[:name] + '@' + sid
                      end
    sid
  end

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('SID')
  end
end
