newparam(:resource_title) do
  desc <<-EOD
    The title of the resource you want to manage. It is the part between the `[` and the `]`. In the next example:

        propery_value { 'File[/tmp/a.a]owner':
          ...
        }

    `/tmp/a.a` is the type name.

  EOD

  isnamevar
end
