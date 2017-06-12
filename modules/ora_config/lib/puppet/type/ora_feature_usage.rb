require 'easy_type'
require 'easy_type/helpers'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet_x/enterprisemodules/oracle/settings'

module Puppet
  #
  Type.newtype(:ora_feature_usage) do
    include EasyType
    include EasyType::Helpers
    extend Puppet_X::EnterpriseModules::Oracle::TitleParser
    include Puppet_X::EnterpriseModules::Oracle::Settings

    desc <<-EOD

      This resource allows you to report on Database feature usage

          ora_feature_usage { '<feature>@<database>':
            max_usage => 200,
            when_used => 'warning|error',
          }

      Managable features are:

          - 'active_data_guard'
          - 'advanced_analytics'
          - 'advanced_compression'
          - 'advanced_security'
          - 'change_management_pack'
          - 'configuration_management_pack_for_oracle_database'
          - 'data_masking_pack'
          - 'database_gateway'
          - 'database_in-memory'
          - 'database_vault'
          - 'diagnostics_pack'
          - 'exadata'
          - 'goldengate'
          - 'hw'
          - 'label_security'
          - 'multitenant'
          - 'olap'
          - 'partitioning'
          - 'pillar_storage'
          - 'provisioning_and_patch_automation_pack'
          - 'provisioning_and_patch_automation_pack_for_database'
          - 'rac_or_rac_one_node'
          - 'real_application_clusters'
          - 'real_application_clusters_one_node'
          - 'real_application_testing'
          - 'secure_backup'
          - 'spatial_and_graph'
          - 'tuning_pack'
          - 'webLogic_server_management_pack_enterprise_edition'

    EOD

    feature_map = { 'active_data_guard'                                   => ['Active Data Guard - Real-Time Query on Physical Standby',
                                                                              'Global Data Services'],
                    'advanced_analytics'                                  => ['Data Mining'],
                    'advanced_compression'                                => ['ADVANCED Index Compression',
                                                                              'Advanced Index Compression',
                                                                              'Backup HIGH Compression',
                                                                              'Backup LOW Compression',
                                                                              'Backup MEDIUM Compression',
                                                                              'Backup ZLIB Compression',
                                                                              'Data Guard',
                                                                              'Flashback Data Archive',
                                                                              'HeapCompression',
                                                                              'Heat Map',
                                                                              'Hybrid Columnar Compression Row Level Locking',
                                                                              'Information Lifecycle Management',
                                                                              'Oracle Advanced Network Compression Service',
                                                                              'Oracle Utility Datapump (Export)',
                                                                              'Oracle Utility Datapump (Import)',
                                                                              'SecureFile Compression (user)',
                                                                              'SecureFile Deduplication (user)'],
                    'advanced_security'                                   => ['Backup Encryption',
                                                                              'Data Redaction',
                                                                              'Encrypted Tablespaces',
                                                                              'Oracle Utility Datapump (Export)',
                                                                              'Oracle Utility Datapump (Import)',
                                                                              'SecureFile Encryption (user)',
                                                                              'Transparent Data Encryption'],
                    'change_management_pack'                              => ['Change Management Pack'],
                    'configuration_management_pack_for_oracle_database'   => ['EM Config Management Pack'],
                    'data_masking_pack'                                   => ['Data Masking Pack'],
                    'database_gateway'                                    => ['Gateways',
                                                                              'Transparent Gateway'],
                    'database_in-memory'                                  => ['In-Memory Aggregation',
                                                                              'In-Memory Column Store'],
                    'database_vault'                                      => ['Oracle Database Vault',
                                                                              'Privilege Capture'],
                    'diagnostics_pack'                                    => ['ADDM',
                                                                              'AWR Baseline',
                                                                              'AWR Baseline Template',
                                                                              'AWR Report',
                                                                              'Automatic Workload Repository',
                                                                              'Baseline Adaptive Thresholds',
                                                                              'Baseline Static Computations',
                                                                              'Diagnostic Pack',
                                                                              'EM Performance Page'],
                    'exadata'                                             => ['Exadata'],
                    'goldengate'                                          => ['GoldenGate'],
                    'hw'                                                  => ['Hybrid Columnar Compression',
                                                                              'Hybrid Columnar Compression Row Level Locking',
                                                                              'Sun ZFS with EHCC',
                                                                              'ZFS Storage',
                                                                              'Zone maps'],
                    'label_security'                                      => ['Label Security'],
                    'multitenant'                                         => ['Oracle Multitenant',
                                                                              'Oracle Pluggable Databases'],
                    'olap'                                                => ['OLAP - Analytic Workspaces',
                                                                              'OLAP - Cubes'],
                    'partitioning'                                        => ['Partitioning (user)',
                                                                              'Zone maps'],
                    'pillar_storage'                                      => ['Pillar Storage',
                                                                              'Pillar Storage with EHCC'],
                    'provisioning_and_patch_automation_pack'              => ['EM Standalone Provisioning and Patch Automation Pack'],
                    'provisioning_and_patch_automation_pack_for_database' => ['EM Database Provisioning and Patch Automation Pack'],
                    'rac_or_rac_one_node'                                 => ['Quality of Service Management'],
                    'real_application_clusters'                           => ['Real Application Clusters (RAC)'],
                    'real_application_clusters_one_node'                  => ['Real Application Cluster One Node'],
                    'real_application_testing'                            => ['Database Replay: Workload Capture',
                                                                              'Database Replay: Workload Replay',
                                                                              'SQL Performance Analyzer'],
                    'secure_backup'                                       => ['Oracle Secure Backup'],
                    'spatial_and_graph'                                   => ['Spatial'],
                    'tuning_pack'                                         => ['Automatic Maintenance - SQL Tuning Advisor',
                                                                              'Automatic SQL Tuning Advisor',
                                                                              'Real-Time SQL Monitoring',
                                                                              'SQL Access Advisor',
                                                                              'SQL Monitoring and Tuning pages',
                                                                              'SQL Profile',
                                                                              'SQL Tuning Advisor',
                                                                              'SQL Tuning Set (user)',
                                                                              'Tuning Pack'],
                    'webLogic_server_management_pack_enterprise_edition'  => ['EM AS Provisioning and Patch Automation Pack'] }

    to_get_raw_resources do
      statement = <<-EOS.freeze
        select name
             , detected_usages
          from dba_feature_usage_statistics
         where currently_used = 'TRUE'
         order by 1
      EOS
      result = sql_on_all_database_sids statement
      # TODO: Make the part below less complicated
      features_hash = result.map do |hash|
        feature_map.map do |option, features|
          entry = []
          if features.include? hash['NAME']
            entry = Hash['SID' => hash['SID'], 'OPTION' => option, 'USAGE' => hash['DETECTED_USAGES'].to_i]
          end
          entry
        end
      end.flatten.compact
      features_hash.group_by { |element| [element['SID'], element['OPTION']] }.map do |group, hashes|
        { 'SID' => group[0], 'OPTION' => group[1], 'USAGE' => hashes.map { |h| h['USAGE'] }.inject(:+) }
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

    parameter :name
    property  :max_usage
    parameter :when_used

  end
end
