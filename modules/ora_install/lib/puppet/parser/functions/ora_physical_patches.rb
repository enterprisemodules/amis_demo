module Puppet
  module Parser
    module Functions
      #
      # This function will take a ora_opatch resource list and will transform it
      # into a list of physical patches. This means it will check all sub_patches 
      # and if they exist, change the main patch into multiple sub patches
      #
      #
      newfunction(:ora_physical_patches, :type => :rvalue) do |args|
        return [] if args[0].nil?
        resources = Hash(args[0])
        resources.keys.collect do | full_patch_id|
          oracle_home, patch_id = full_patch_id.split(':')
          sub_patches = resources[full_patch_id]['sub_patches']
          if sub_patches
            sub_patches.collect {|p| "#{oracle_home}:#{p}"}
          else
            full_patch_id
          end
        end.flatten
      end
    end
  end
end
