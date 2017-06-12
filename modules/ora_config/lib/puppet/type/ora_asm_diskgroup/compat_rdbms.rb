newproperty(:compat_rdbms) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase
  include Puppet_X::EnterpriseModules::Oracle::Access

  desc <<-EOD
    The compatible rdbms attribute of the diskgroup.

    This specifies the RDBMS compatibility of the diskgroup. The valid values depend on the version of ASM and Oracle
    you are using. At this point in time the next set of values are valid:

    - `10.1`
    - `11.2`
    - `12.1`

    Here is an example:

        ora_asm_diskgroup{ ...
          ...
          compat_rdbms => '11.2'
        }

    When you don't specify a value, Oracle will decide the default value. Agin, the actual value depends on
    the version of Oracle you are using. Check the Oracle documentation documentation of your version.

  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('DATABASE_COMPATIBILITY').upcase
  end

  #
  # If the string length of the actual value is longer the the string length of the specified value,
  # only check if they are equal for the given string
  # example:
  #  12.1 == 12.1.0.0
  #
  def insync?(is)
    length = should.length
    is.slice(0, length) == should
  end

  on_modify do
    sql("alter diskgroup #{resource.groupname} set attribute 'compatible.rdbms' = '#{value}'", :sid => resource.asm_sid)
    nil
  end

  def to_sql
    "'compatible.rdbms' = '#{value}'"
  end

end
