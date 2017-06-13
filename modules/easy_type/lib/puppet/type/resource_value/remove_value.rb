newproperty(:remove_value) do
  include EasyType

  desc <<-EOD
    The value you want to remove an entry from the array resource property.

    Here is an example on how to use this:

        ora_user { 'USER@test':
          ensure               => 'present',
          default_tablespace   => 'USERS',
          grants               => ['ALTER SYSTEM', 'ALTER DATABASE', 'SELECT ANY DICTIONARY', 'CONNECT'],
        }

    Somewhere else in your manifest, you want to remove some of these grants. You can do this like this:

        resource_value{'Ora_user[USER@test]grants/1':
          remove_value => 'SELECT ANY DICTIONARY',
        }

    The `remove_value` property also supports an array value:

        resource_value{'Ora_user[USER@test]grants/more_grants':
          remove_value => ['ALTER SESSION', 'CONNECT'],
        }

  EOD
end
