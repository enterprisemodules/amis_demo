# encoding: UTF-8
newparam(:contained_by) do
  include EasyType

  desc <<-EOD
    Specify the SID of the container database where the pluggable databases should be part of.
    This parameter is mandatory when creating a pluggable databases.

        ora_database { 'my_database':
          ensure             => present,
          ...
          contained_by       => 'CDB',
          ...
        }

  EOD

end
