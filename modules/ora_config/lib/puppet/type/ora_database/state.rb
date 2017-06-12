# encoding: UTF-8
newproperty(:state) do
  include EasyType

  newvalues(:running, :stopped)

  desc <<-EOD
    State of the database, either runnuning or stopped.
  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('STATE')
  end
end
