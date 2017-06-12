# encoding: UTF-8
newparam(:volume_device) do
  include EasyType

  desc <<-EOD
    The device the volume is created on.

    This required parameter must be a valid empry folder, the volume will be mounted on.

        ora_asm_volume { ...:
          ...
          volume_device => '/mnt/oravolume',
        }

  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('VOLUME_DEVICE')
  end
end
