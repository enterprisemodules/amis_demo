# encoding: UTF-8
newparam(:file_name_convert) do
  include EasyType

  desc <<-EOD
    Specify the conversion rules for seed files of pluggable databases
    Enable or disable the containers and adding pluggable databases

        ora_database { 'my_database':
          ensure             => present,
          ...
          container_database => 'enabled',
          file_name_convert  => {/oracle/dbs/' =>'/oracle/pdbseed/',}
          ...
        }

    This will create a container database and convert all file names from the seed database containing
    `/oracle/dbs/` to `/oracle/pdbseed`.

  EOD

  #
  # TODO: Add validation
  #

  on_apply do
    "seed file_name_convert = ('#{value.keys.first}', '#{value.values.first}')"
  end

end
