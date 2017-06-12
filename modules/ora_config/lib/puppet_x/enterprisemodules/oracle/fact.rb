require 'pathname'
require 'puppet'
module_path = Pathname.new(__FILE__).dirname.parent.parent.parent.parent.parent
$LOAD_PATH.unshift(module_path + 'ora_config' + 'lib')
$LOAD_PATH.unshift(module_path + 'easy_type' + 'lib')
require 'puppet_x/enterprisemodules/oracle/access'

module PuppetX
  # Doc
  module Oracle
    # Docs
    # TODO: Write documentation
    module Fact
      def ora_fact(_mappings = {})
        fail 'ora_fact no longer supported. Choose either ora_record_fact or ora_array_fact'
      end

      def ora_array_fact(mappings = {}, &proc)
        query_routine = lambda { |query| sql_on_all_database_sids(query) }
        mapper        = lambda { |results, lambda_mappings| array_mapper(results, lambda_mappings) }
        ora_fact_internal(query_routine, mapper, mappings, &proc)
      end

      def mt_array_fact(mappings = {}, &proc)
        query_routine = lambda { |query| sql_on_all_mt_sids(query) }
        mapper        = lambda { |results, lambda_mappings| array_mapper(results, lambda_mappings) }
        ora_fact_internal(query_routine, mapper, mappings, &proc)
      end

      def asm_array_fact(mappings = {}, &proc)
        query_routine = lambda { |query| sql_on_all_asm_sids(query) }
        mapper        = lambda { |results, lambda_mappings| array_mapper(results, lambda_mappings) }
        ora_fact_internal(query_routine, mapper, mappings, &proc)
      end

      def ora_record_fact(mappings = {}, &proc)
        query_routine = lambda { |query| sql_on_all_database_sids(query) }
        mapper        = lambda { |results, lambda_mappings| record_mapper(results, lambda_mappings) }
        ora_fact_internal(query_routine, mapper, mappings, &proc)
      end

      def mt_record_fact(mappings = {}, &proc)
        query_routine = lambda { |query| sql_on_all_mt_sids(query) }
        mapper        = lambda { |results, lambda_mappings| record_mapper(results, lambda_mappings) }
        ora_fact_internal(query_routine, mapper, mappings, &proc)
      end

      def asm_record_fact(mappings = {}, &proc)
        query_routine = lambda { |query| sql_on_all_asm_sids(query) }
        mapper        = lambda { |results, lambda_mappings| record_mapper(results, lambda_mappings) }
        ora_fact_internal(query_routine, mapper, mappings, &proc)
      end

      def ora_fact_internal(query_routine, mapper, mappings = {})
        query = yield
        setcode do
          extend Puppet_X::EnterpriseModules::Oracle::Access
          extend EasyType::Helpers

          results = query_routine.call(query)
          mapper.call(results, mappings)
        end
      end

      def no_mappings(result)
        result.delete('SID')
        result[result.keys.first]
      end

      def array_mapper(results, mappings)
        results.collect do |result|
          if mappings == {}
            no_mappings(result)
          else
            return_value = mappings.collect do |key, entry|
              [key.to_s, result[entry]]
            end.flatten
            Hash[*return_value]
          end
        end
      end

      def record_mapper(result, mappings)
        result = result.first
        if mappings == {}
          no_mappings(result)
        else
          return_value = mappings.collect do |key, entry|
            [key.to_s, result[entry]]
          end
          Hash[return_value]
        end
      end
    end
  end
end
