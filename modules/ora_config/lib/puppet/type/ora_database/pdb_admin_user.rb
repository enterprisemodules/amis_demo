newparam(:pdb_admin_user) do
  include EasyType

  defaultto 'PDB_ADMIN'

  desc <<-EOD
    Specify the admin user for the pluggable database.
    This parameter is mandatory when creating a pluggable databases.

    ora_database { 'my_database':
      ensure             => present,
      ...
      pdb_admin_user     => 'password',
      ...
    }
  EOD

  on_apply do
    "admin user #{value}"
  end
end
