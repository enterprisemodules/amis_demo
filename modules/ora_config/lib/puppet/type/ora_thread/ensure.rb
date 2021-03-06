newproperty(:ensure) do
  include EasyType

  desc <<-EOD
    Whether the thread is enabled.
  EOD

  newvalues(:enabled, :disabled)

  to_translate_to_resource do |raw_resource|
    value = raw_resource.column_data('ENABLED').downcase
    value == 'disabled' ? 'disabled' : 'enabled' # make private and public both seen as enabled
  end
end
