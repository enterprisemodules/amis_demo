newparam(:force) do
  include EasyType

  desc <<-EOD
    Enable force diskmount when chaning the state of the diskgroup.,

    When you specify this when unmounting a diskgroup, ASM will force a dismount.

        ora_asm_diskgroup {...:
          ...
          diskgroup_state => 'UNMOUNTED'
          force           => true,
        }

  EOD

  defaultto(:false)
  newvalues(:true, :false)
end
