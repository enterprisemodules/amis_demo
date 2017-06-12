newparam(:property_name) do
  desc <<-EOD
    The property of the resource you want to manage. It is the part after the `]`. In the next example:

        propery_value { 'File[/tmp/a.a]owner':
          ...
        }

    `owner` is the property name.

  EOD

  isnamevar
end
