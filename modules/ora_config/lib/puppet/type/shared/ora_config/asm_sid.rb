#
# Although this file is named asm_sid, the name of the parameter is and should be
# sid. This is done to distinguish between a default asm sid and a default database
# sid
#
newparam(:asm_sid) do
  include EasyType

  desc <<-EOD
    ASM SID to connect to.

    All types have a name like `resource@sid`. The sid is optional. If you don't specify the sid, the type
    will use the ASM instance from the `/etc/ora_settings.yaml` with the name `default_asm`. We advise you to
    either use `@sid` in all your manifests or leave it empty everywhere.
  EOD

  isnamevar

  defaultto 'default_asm'

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('SID')
  end
end
