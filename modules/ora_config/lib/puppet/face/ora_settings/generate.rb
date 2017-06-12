require 'puppet/face'
require 'puppet_x/enterprisemodules/oracle/ora_tab'
require 'puppet/type/ora_setting'

Puppet::Face.define(:ora_settings, '0.0.1') do
  action(:generate) do
    default

    summary 'Generate a ora_sttings file based on the oratab'

    description <<-EOT
      Generate a ora_sttings file based on the oratab
    EOT

    when_invoked do |*_arguments|
      oratab = Puppet_X::EnterpriseModules::Oracle::OraTab.new
      default_database_set = false
      oratab.entries.each do |entry|
        if entry[:sid] =~ /ASM/
          syspriv = 'sysasm'
          default_database = false
        else
          syspriv = 'sysdba'
          if default_database_set
            default_database = false
          else
            default_database = true
            default_database_set = true
          end
        end
        settings = Puppet::Type::Ora_setting.new(:name => entry[:sid],
                                                 :oracle_home    => entry[:home],
                                                 :default        => default_database,
                                                 :syspriv        => syspriv,
                                                 :connect_string => '',
                                                 :pluggable      => false,
                                                 :cdb            => false,
                                                 :user           => '')
        settings.add
      end
      Puppet.notice "#{oratab.entries.size} sid's written to ora_settings"
      ''
    end
  end
end
