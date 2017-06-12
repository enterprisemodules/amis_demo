require '/etc/puppet/modules/ora_config/lib/puppet_x/enterprisemodules/oracle/fact'
include PuppetX::Oracle::Fact

Facter.add('rac_cluster') do
  ora_record_fact do
    'select parallel from v$instance'
  end
end
