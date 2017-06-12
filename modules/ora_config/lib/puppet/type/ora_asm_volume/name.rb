newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::String

  desc <<-EOD
    The full asm volume name including  diskgroup name and SID.

    The full ASM volume nane name contains a diskgroup a volume name and an SID.

        ora_asm_volume { "diskgroup:my_volume@+ASM1":
          ...
        }

    The SID is optional. When you don't specify an SID, Puppet will take the first ASM instance
    from the `/etc/oratab` file and use that as the SID. We recoomend you **always** use a full qualified
    name (e.g. a name including the SID).

  EOD

  isnamevar

  to_translate_to_resource do |raw_resource|
    asm_sid = raw_resource.column_data('SID')
    diskgroup   = raw_resource.column_data('DISKGROUP').upcase
    volume_name = raw_resource.column_data('VOLUME_NAME').upcase
    "#{diskgroup}:#{volume_name}@#{asm_sid}"
  end
end
