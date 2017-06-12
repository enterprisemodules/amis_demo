#
# Check all requirements for facts
#
def ora_define_fact(fact_name)
  require "#{File.dirname(__FILE__)}/fact"
  include PuppetX::Oracle::Fact

  Facter.add("ora_#{fact_name}") do
    #
    # For now only accept these facts when the primary database is Oracle12
    #
    confine do
      Puppet.features.oracle12? && Puppet.features.oracle_running?
    end

    ora_array_fact(:name => 'NAME', :sid =>'SID') do
      yield
    end
  end
end
