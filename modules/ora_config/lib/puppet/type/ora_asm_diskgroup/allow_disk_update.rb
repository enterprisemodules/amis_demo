newparam(:allow_disk_update) do
  include EasyType

  desc <<-EOD
    When set to true, allow the puppet type to update the disks.

    Changing this disks in an ASM diskgroup is a potentialy destructive operation. That is why
    by default we disable this operation. If however this is required for your use case, you can set
    the parameter to `true`. In that case, changes in the manifest will resuilt in changes beeing made to
    the running system.

    Here is an example:

        ora_asm_diskgroup {...:
          ...
          disks             = [....],
          allow_disk_update => true,
        }

    This parameter only guards the disks property of the type. When changed in the manifest, all other
    properties of `ora_asm_diskgroup` will be updated regardless of this setting.

  EOD

  defaultto(:false)
  newvalues(:true, :false)
end
