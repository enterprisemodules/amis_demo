newparam(:resource_type) do
  desc <<-EOD
    The name of the type you want to manage. It is the first part of the title. In the next example:

        propery_value { 'File[/tmp/a.a]owner':
          ...
        }

    `File` is the type name.

  EOD

  isnamevar
end
