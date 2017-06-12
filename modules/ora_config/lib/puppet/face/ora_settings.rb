require 'puppet/face'

Puppet::Face.define(:ora_settings, '0.0.1') do
  option '--default SID', '-d NAME' do
    summary 'SID to use as default'
    description <<-EOT
    SID to use as default
    EOT
  end
end
