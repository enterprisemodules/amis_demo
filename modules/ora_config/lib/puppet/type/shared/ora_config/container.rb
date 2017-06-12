newproperty(:container) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::Information

  desc <<-EOD
    Allows you to specify the scope of the object.

    This property is only supported on version 12 and higher. It allows you to specify if the user
    will be seen through all portable containers (e.g. global) of just in the current
    pluggable database.

    You can use `container` on:

    - `ora_user`
    - `ora_profile`
    - `ora_object_grant`

    Here is an example on how to use this:

        ora_... { '...@sid':
          ...
          container       => 'current',
          ...
        }
  EOD

  newvalues(:current, :all)

  to_translate_to_resource do |raw_resource|
    #
    # First get the value from the raw resource. If 'COM' is filled. It means
    # we are on Oracle 12 and can use the containerdb?(sid) to decide
    # if we want to return the value.
    #
    sid = raw_resource['SID']
    value = case raw_resource['COM']
            when nil then nil
            when 'NO' then :current
            when 'YES' then :all
            else
              fail 'invalid value received from column COMMON'
            end
    return value if value && containerdb?(sid)
    nil
  end

  on_modify do
    fail 'Modification of the container property not allowed'
  end

  on_create do
    "container = #{value}"
  end
end
