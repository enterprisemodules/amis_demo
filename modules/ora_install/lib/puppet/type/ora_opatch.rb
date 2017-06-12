require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'easy_type/helpers'

module Puppet
  #
  Type.newtype(:ora_opatch) do
    include EasyType
    include EasyType::Helpers

    desc 'This resource allows you to manage opatch patches on a specific database home.'

    ensurable

    # validate do
    #   fail "Source is a required attribute for #{name}." unless source
    # end

    set_command([:opatch, :opatchauto])

    to_get_raw_resources do
      provider(:base).installed_patches
    end

    on_create do |command_builder|
      provider.apply_patch(get_patches, command_builder)
      remove_unzipped_file(source, command_builder)
    end

    on_modify do |command_builder|
      raise 'Internal error. A patch is either there ot not. It cannot be modified.'
    end

    on_destroy do |command_builder|
      #
      # Only the opatchauto requires the source to be extracted
      # The other providers use stored information.
      #
      if provider.name == :opatchauto
        get_patches
        remove_unzipped_file(source, command_builder)
      else
        provider.remove_patch('', command_builder)
      end
    end

    map_titles_to_attributes([
      /^((.*):(.*))$/, [:name, :oracle_product_home_dir, :patch_id]
    ])

    parameter :name
    parameter :patch_id
    parameter :oracle_product_home_dir
    parameter :orainst_dir
    parameter :ocmrf_file
    parameter :source
    parameter :tmp_dir
    parameter :source_dir
    parameter :sub_patches
    property  :comment

    def opatch(command, options = {})
      provider.opatch(command, options)
    end

    def opatchauto(command, options = {})
      provider.opatchauto(command, options)
    end

    def generate
      #
      # Add news resources to the catalog based on the sub_patches
      #
      if sub_patches && sub_patches.any?
        if puppet_version_lower_then('4.4.0')
          #
          # Below version 4.4.0, Puppet doesn't recognise the relations
          # between the major resource and resources generated by `generate`.
          #
          # This means all generated resources will be positioned at the end.
          # For ora_opatches, this is **not** good. We need to manage the ordering
          # of patches. Therefor we skip this function when Puppet version is to low.
          #
          raise 'Using sub_patches needs Puppet 4.4.0 or higher.'
        end
        resources = sub_patches.collect do |sub_patch|
          hash = to_hash
          hash[:name] = "#{oracle_product_home_dir}:#{sub_patch}"
          hash[:patch_id] = sub_patch

          hash.delete(:sub_patches)
          self.class.new(hash)
        end
        self[:ensure] = :absent
        resources
      end
    end

    def get_patches
      parameters[:source].process
      FileUtils.chmod_R(0o777, source) # So oracle and grid users can access them
      check_source_dir(source)
    end

    def check_source_dir(parent)
      patch_source_dir = Dir.glob("#{parent}/**/#{source_dir}").first
      raise "#{source} doesn't contain folder #{source_dir}" unless patch_source_dir
      patch_source_dir
    end

    def remove_unzipped_file(source, command_builder)
      command_builder.after("-rf #{tmp_dir}", :rm)
    end

    def puppet_version_lower_then(version)
      current_version = Gem::Version.new(Puppet.version)
      requested_version = Gem::Version.new(version)
      current_version <= requested_version
    end
  end
end
