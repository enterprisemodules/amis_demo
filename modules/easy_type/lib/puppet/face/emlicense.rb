require 'puppet/face'
require 'easy_type'

Puppet::Face.define(:emlicense, '0.0.1') do

  option '--puppetserver NAME', '-p NAME' do
    summary 'Name of the puppet server. '
    description <<-EOT
      Name of the puppet server.
    EOT
  end
end
