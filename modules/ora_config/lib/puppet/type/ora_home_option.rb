require 'easy_type'
require 'easy_type/helpers'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/settings'

module Puppet
  #
  Type.newtype(:ora_home_option) do
    include EasyType
    include EasyType::Helpers
    extend Puppet_X::EnterpriseModules::Oracle::TitleParser
    include Puppet_X::EnterpriseModules::Oracle::Settings

    desc <<-EOD

      This resource allows you to manage(enable/disable) options in an Oracle database home.

          ora_home_option { '/u01/app/oracle/product/12.1.0/db_home1':
            datamining               => 'disabled',
            direct_nfs               => 'disabled',
            olap                     => 'disabled',
            partitioning             => 'disabled',
            real_application_testing => 'disabled',
          }

    EOD

    to_get_raw_resources do
      homes = configuration.collect { |x,y|  y['oracle_home'] }.uniq
      homes.collect do |home|
        entry = {}
        entry['NAME'] = home
        options = { :failonfail => true, :combine => true }
        result = Puppet::Util::Execution.execute("su - oracle -c \"ar -t #{home}/rdbms/lib/libknlopt.a\"", options).split(/\n/)
        dnfs_result = Puppet::Util::Execution.execute("su - oracle -c \"if ls #{home}/rdbms/lib/odm/libnfsodm??.so 2>&1 > /dev/null; then echo libnfsodm.so; else echo libnonfsodm.so; fi\"", options).split(/\n/)
        all_results = result + dnfs_result
        db_options = ['DM', 'OLAP', 'PART', 'RAT', 'DNFS']
        db_options.collect do |option|
          if option == 'DM'
            lib = all_results.select { |x| x =~ /dmndm.o|dmwdm.o/ }.first
            entry['DM'] = lib == 'dmndm.o' ? 'disabled' : 'enabled'
          elsif option == 'OLAP'
            lib = all_results.select { |x| x =~ /xsnoolap.o|xsyeolap.o/ }.first
            entry['OLAP'] = lib == 'xsnoolap.o' ? 'disabled' : 'enabled'
          elsif option == 'PART'
            lib = all_results.select { |x| x =~ /ksnkkpo.o|kkpoban.o/ }.first
            entry['PART'] = lib == 'ksnkkpo.o' ? 'disabled' : 'enabled'
          elsif option == 'RAT'
            lib = all_results.select { |x| x =~ /kecnr.o|kecwr.o/ }.first
            entry['RAT'] = lib == 'kecnr.o' ? 'disabled' : 'enabled'
          elsif option == 'DNFS'
            lib = all_results.select { |x| x =~ /libnonfsodm.so|libnfsodm.so/ }.first
            entry['DNFS'] = lib == 'libnonfsodm.so' ? 'disabled' : 'enabled'
          end
        end
        entry
      end
    end

    on_create do
      nil
    end

    on_modify do
      # Allow individual properties to do their stuff
    end

    on_destroy do
      nil
    end

    map_title_to_sid(:name)

    parameter :name
    property  :datamining
    property  :olap
    property  :partitioning
    property  :direct_nfs
    property  :real_application_testing

  end
end
