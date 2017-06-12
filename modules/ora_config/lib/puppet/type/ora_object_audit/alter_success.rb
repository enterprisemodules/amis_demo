newproperty(:alter_success) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::AuditProperty

  desc <<-EOD
    Auditing option for the issuance of a successful ALTER operation on that object.

    here is an example on how to use this:

        ora_object_audit { 'SYS.AUD$@test':
          ensure        => 'present',
          ...
          alter_success => 'on_access',
          ...
        }

    This enables the auditing of successful alters on the table `AUD$` from user `SYS`. An
    audit record is written on every access.

  EOD

  entry('ALT')

end
