newparam(:pdb_admin_password) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Utilities

  defaultto generated_password(12)

  desc <<-EOD
    Specify the password for the admin user of the pluggable database.
    This parameter is mandatory when creating a pluggable databases.

    ora_database { 'my_database':
      ensure             => present,
      ...
      pdb_admin_password => 'password',
      ...
    }
  EOD

  on_apply do
    "identified by #{value}"
  end
end
