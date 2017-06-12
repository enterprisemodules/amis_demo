require '/etc/puppet/modules/ora_config/lib/puppet_x/enterprisemodules/oracle/fact'
include PuppetX::Oracle::Fact

Facter.add('ora_user_tablespace') do
  mappings = {
    :name       => 'TABLESPACE_NAME',
    :block_size => 'BLOCK_SIZE'
  }
  ora_record_fact(mappings) do
    'select * from dba_tablespaces where tablespace_name = \'USERS\''
  end
end

require '/etc/puppet/modules/ora_config/lib/puppet_x/enterprisemodules/oracle/fact'
include PuppetX::Oracle::Fact

Facter.add('ora_tablespaces') do
  mappings = {
    :name       => 'TABLESPACE_NAME',
    :block_size => 'BLOCK_SIZE'
  }
  ora_array_fact(mappings) do
    'select * from dba_tablespaces'
  end
end
