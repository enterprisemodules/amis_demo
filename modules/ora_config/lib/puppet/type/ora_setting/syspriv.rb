newproperty(:syspriv) do
  include EasyType::YamlProperty

  desc <<-EOD
    The privilege used to connect to the database or asm.

    You need to set this depending on the type of database.

        ora_setting { 'DB1':
          syspriv => 'sysdba',
        }


  EOD
  defaultto 'sysdba'
  newvalues(:normal, :sysdba, :sysasm, :sysoper, :sysbackup, :sysdg, :syskm)
end
