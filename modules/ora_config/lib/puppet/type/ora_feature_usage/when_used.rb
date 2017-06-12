newparam(:when_used) do
  include EasyType

  newvalues(:warning, :WARNING, :error, :ERROR)

  desc <<-EOD

      This resource allows you to specify which type of alert(warning or error) you want when max_usage is reached.

          ora_feature_usage { 'advanced_compression@dbname':
            ...
            when_used => 'warning|error',
            ...
          }

  EOD

  defaultto :warning

end
