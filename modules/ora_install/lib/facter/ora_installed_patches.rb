require 'facter'
require 'etc'

#
# Fetch all installed oracle patches on all regisstered oracle homes
#
# The information is returned as an array with the next content:
#
#  ['/oracle/home:patchid','/oracle/home2:patchid'...]
#
#
Facter.add('ora_installed_patches') do
  setcode do
    begin
      installed_patches
    rescue
      # Rescue all error's. We don't want errors during facts
      []
    end
  end
end

def execute(command, user)
  full_command = if user
                   "su - #{user} -c \"#{command}\""
                 else
                   command
                 end
  `#{full_command}`
end

def installed_patches
  oracle_homes.collect do |oracle_home|
    ora_user = user_for_file(oracle_home)
    patches_in_home(oracle_home, ora_user, ora_invdir)
  end.flatten
end

def oracle_homes
  oratab_content.scan(/^(?!#).*\:(.*)\:.*$/).flatten.uniq
end

def user_for_file(home)
  #
  # To run opatch, we need the owner of the grid and oracle directory. The mechanism
  # we use to get this user, is to fetch the owner of the bin directory in the grid or
  # oracle home. Sometimes however, these directories also contain files with root as owner.
  # since root can never be the user of the grid or oracle processen, we skip those.
  #
  a_file = first_non_root_file(home)
  uid = File.stat("#{home}/#{a_file}").uid
  Etc.getpwuid(uid).name
end

def opatch_installed?(oracle_home)
  File.exist?("#{oracle_home}/OPatch/opatch")
end

def first_non_root_file(dir)
  Dir.new(dir).each { |file| break file if File.stat("#{dir}/#{file}").uid.nonzero? }
end

def patches_in_home(oracle_product_home_dir, os_user, orainv_dir)
  if opatch_installed?(oracle_product_home_dir)
    full_command = "#{oracle_product_home_dir}/OPatch/opatch lsinventory -oh #{oracle_product_home_dir} -invPtrLoc #{orainv_dir}/oraInst.loc"
    raw_list = execute(full_command, os_user)
    patch_ids = raw_list.scan(/Patch\s.(\d+)\s.*:\sapplied on/).flatten
    patch_ids.collect { |p| "#{oracle_product_home_dir}:#{p}" }
  else
    #
    # When Opatch is not installed, we don't report any patches
    #
    []
  end
end

def oratab_content
  File.read(oratab_file)
end

def oratab_file
  "#{ora_invdir}/oratab"
end

def ora_invdir
  os = Facter.value(:kernel)
  case os
  when 'Linux' then
    '/etc'
  when 'SunOS' then
    '/var/opt/oracle'
  else
    '/etc'
  end
end
