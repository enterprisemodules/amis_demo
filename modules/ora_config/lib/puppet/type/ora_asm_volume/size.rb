# encoding: UTF-8
newproperty(:size) do
  include EasyType

  desc <<-EOD
    The size of the volume to ensure. The size is specified in Mb's.

    This is a required property.

        ora_asm_volume { ...:
          ...
          size => '100M',
        }

  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('SIZE')
  end
end
