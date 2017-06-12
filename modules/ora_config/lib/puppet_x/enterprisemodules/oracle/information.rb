module Puppet_X
  module EnterpriseModules
    module Oracle
      # Docs
      module Information
        def self.included(parent)
          parent.extend(Information)
        end

        def cached_sid_value(name, sid)
          @@cache ||= {}
          @@cache[name] ||= {}
          if @@cache[name][sid].nil?
            @@cache[name][sid] = yield
          else
            Puppet.debug "Using cached version of #{name} for sid #{sid}."
            @@cache[name][sid]
          end
        end

        def cluster?(on_sid = sid)
          cached_sid_value(:cluster, on_sid) { sql('select parallel as par from v$instance', :sid => on_sid).first['PAR'] == 'YES' }
        end

        def containerdb?(on_sid = sid)
          oracle_major_version(on_sid) >= 12 &&  cached_sid_value(:containerdb, on_sid) { sql('SELECT CDB FROM V$DATABASE', :sid => on_sid).first['CDB'] == 'YES' }
        end

        def rootdb?(on_sid = sid)
          oracle_major_version(on_sid) >= 12 &&  cached_sid_value(:rootdb, on_sid) { sql('select con_id from v$database', :sid => on_sid).first['CON_ID'] == 0 }
        end

        def seeddb?(on_sid = sid)
          oracle_major_version(on_sid) >= 12 && cached_sid_value(:seeddb, on_sid) { sql('select con_id from v$database', :sid => on_sid).first['CON_ID'] == 1 }
        end

        def pdb?(on_sid = sid)
          oracle_major_version(on_sid) >= 12 && cached_sid_value(:pdb, on_sid) { sql('select con_id from v$database', :sid => on_sid).first['CON_ID'].to_i > 1 }
        end

        def cluster_instances(on_sid = sid)
          cached_sid_value(:cluster_instances, on_sid) { sql('select INSTANCE_NAME from gv$instance', :sid => on_sid).collect { |e| e['INSTANCE_NAME'] } }
        end

        def database_version(on_sid = sid)
          cached_sid_value(:database_version, on_sid) { sql("select version from product_component_version where product like 'Oracle Database%'", :sid => on_sid).first['VERSION'] }
        end

        def db_domain(on_sid = sid)
          cached_sid_value(:db_domain, on_sid) { sql("select value from v$parameter where name = 'db_domain'", :sid => on_sid).first['VALUE'] }
        end

        def oracle_major_version(on_sid = sid)
          database_version(on_sid).split('.').first.to_i
        end
      end
    end
  end
end
