newproperty(:create_success) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  include Puppet_X::EnterpriseModules::Oracle::AuditProperty

  desc <<-EOD
    Auditing option for the issuance of a successful CREATE operation on that object.

    here is an example on how to use this:

        ora_object_audit { 'SYS.AUD$@test':
          ensure         => 'present',
          ...
          create_success => 'on_access',
          ...
        }

    This enables the auditing of successful creates on the table `AUD$` from user `SYS`. An
    audit record is written on every access.

  EOD

  entry('CRE')

end
