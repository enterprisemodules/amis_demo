newparam(:editionable) do
  desc <<-EOD

  Whether to use the Edition-based redefinition (EBR) functionality of Oracle12c and higher.

  When you specify a `true` value, Puppet will allow you to use create scripts with the
  `EDITIONABLE` keyword in it. When comparing the actual value in the database with the value
  in the specified creation script, this keyword must be specified for the puppet type to recognise they are the same.

      ora_package {...:
        ...
        editionable   => true,
        ...
      }

  You can use this on both `ora_package` and `ora_trigger`.

  When you specify a value of `false`, the `EDITIONABLE` keyword will be filtered before comparison. This is useful when you have scripts that need to work for a large range of Oracle versions.

  The default value is `false`

  EOD

  defaultto :false

  newvalues(:true, :false)
end
