# encoding: UTF-8
newparam(:container_database) do
  include EasyType

  newvalues(:enabled, :disabled)

  defaultto :disabled

  desc <<-EOD
    Enable or disable the containers and adding pluggable databases

    Using this parameter, you can enable this database,beeing a host for plugganle databases.

        ora_database { 'my_database':
          ensure             => present,
          ...
          container_database => 'enabled',
          ...
        }

    Will enable this database to be a host for pluggable databases. This feature needs Oracle 12 or higher. If you
    use this feature on a database before Oracle 12, SQL will throw an error.

  EOD

  on_apply do
    enabled? ? 'enable pluggable database' : ''
  end

  private

  def enabled?
    value == :enabled
  end
end
