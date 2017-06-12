module Puppet
  module Parser
    module Functions
      #
      # This function checks if the specfied patches are installed. The patch list has the syntax
      #
      #    '/oraclehome/dir:patchid'
      #
      # It will check all registered Oracle homes for the installedd patches.
      #
      newfunction(:ora_patches_installed, :type => :rvalue) do |args|
        return true if args[0].nil?
        patch_list = Array(args[0])
        installed_patches = lookupvar('::ora_installed_patches')
        if ! installed_patches.nil?
          patch_list.all?{|patch| installed_patches.include?(patch)}
        else
          return false
        end
      end
    end
  end
end
