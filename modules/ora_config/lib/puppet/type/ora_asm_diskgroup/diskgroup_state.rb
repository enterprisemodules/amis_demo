newproperty(:diskgroup_state) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access

  desc <<-EOD
    The state of the diskgroup.

    This is an optional property. When you don't specify this value, the default value be `online`.

        ora_asm_diskgroup {...:
          ...
          diskgroup_state => 'mounted'
        }

    When you want to force an unmount, use the `force` property:

        ora_asm_diskgroup {...:
          ...
          diskgroup_state => 'unmounted'
          force           => true,
        }


  EOD

  newvalues('mounted', 'unmounted', 'MOUNTED', 'UNMOUNTED')

  on_modify do
    force = resource.force == :true ? 'force' : ''
    command = case value.to_s.downcase
              when 'mounted'
                "alter diskgroup #{resource.groupname} mount"
              when 'unmounted'
                "alter diskgroup #{resource.groupname} dismount #{force}"
              else
                fail "#{value} is an invalid value for diskgroup_state."
              end
    sql(command, :sid => resource.asm_sid)
    nil
  end

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('STATE').upcase
  end
end
