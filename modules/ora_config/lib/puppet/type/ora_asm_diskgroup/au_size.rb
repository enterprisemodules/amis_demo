newproperty(:au_size) do
  include EasyType
  include EasyType::Mungers::Integer

  desc <<-EOD
    The allocation unit size of the diskgroup in Mb.

        ora_asm_diskgroup { ...:
          ...
          au_size => 2,
        }

    If you don't specify a value, Oracle will decide opn the default value. This is dependent on the
    used Oracle and ASM version.

  EOD

  newvalues(1, 2, 4, 8, 16, 32, 64)

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('ALLOCATION_UNIT_SIZE').to_i / 1024 / 1024
  end

  def insync?(is)
    fail 'Changing au_size is not supported.' if is != should
    true
  end

  def to_sql
    "'au_size' = '#{value}M'"
  end


end
