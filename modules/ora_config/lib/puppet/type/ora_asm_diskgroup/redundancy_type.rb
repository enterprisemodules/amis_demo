newproperty(:redundancy_type) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The redundancy type of the diskgroup.

    This is a required string value. Here is an example:

        ora_asm_diskgroup {...:
          ...
          redundancy_type => 'NORMAL',
        }

  EOD

  defaultto('EXTERN')

  munge do |value|
    value == 'EXTERNAL' ? 'EXTERN' : value
  end

  def insync?(is)
    raise 'Changing diskgroup redundancy_type is not supported.' if is != should
    true
  end

  newvalues('HIGH', 'EXTERN', 'NORMAL')
  aliasvalue('EXTERNAL', 'EXTERN')

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('TYPE').upcase
  end
end

def redundancy_type
  self['redundancy_type'] == 'EXTERN' ? 'EXTERNAL' : self['redundancy_type']
end
