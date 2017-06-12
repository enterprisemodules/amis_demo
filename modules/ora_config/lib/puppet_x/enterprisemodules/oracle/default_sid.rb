# rubocop: disable Style/ClassAndModuleCamelCase
module Puppet_X
  module EnterpriseModules
    module Oracle
      # This modules includes all processing needed to allow consistent behaviour
      # for default resources. Specially on a first run. 
      module DefaultSid
        def self.included(parent)
          current_version = Gem::Version.new(Puppet.version)
          requested_version = Gem::Version.new('3.6.3')
          if current_version <= requested_version
            parent.send(:define_method, :generate) do
              fill_in_default_sid
              []
            end
          else
            parent.send(:define_method, :pre_run_check) do
              fill_in_default_sid
            end
          end
        end

        def fill_in_default_sid
          return if sid
          default_setting = catalog.resources.select { |r| r.type == :ora_setting && r.default == true }
          fail 'You need to specify a the sid or specify a ora_setting in your manifest' if default_setting.empty?
          sid = default_setting.first[:name]
          self[:name] = if self[:name][-1..-1] == '@'
                          self[:name] + sid
                        else
                          self[:name] + '@' + sid
                        end
          self[:sid] = sid
        end
      end
    end
  end
end
