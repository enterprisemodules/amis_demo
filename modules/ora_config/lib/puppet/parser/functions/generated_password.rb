require 'puppet_x/enterprisemodules/oracle/utilities'

module Puppet::Parser::Functions

  newfunction(:generated_password, :type => :rvalue) do |args|
    extend Puppet_X::EnterpriseModules::Oracle::Utilities

    password_length = args[0] || 12
    generated_password(password_length)
  end
end
