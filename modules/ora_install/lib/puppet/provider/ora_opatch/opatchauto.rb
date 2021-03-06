require 'easy_type'

Puppet::Type.type(:ora_opatch).provide(:opatchauto, :parent => :base) do
  desc 'Use the new Opatchauto utility'

  #
  # Regular provider gets all instances already
  #
  def self.instances
    []
  end

  def apply_patch(source_dir, command_builder)
    ocmrf = " -ocmrf #{resource.ocmrf_file}"
    command_builder.add "apply #{source_dir} #{ocmrf} -oh #{oracle_product_home_dir}", :opatchauto
  end

  def remove_patch(source_dir, command_builder)
    ocmrf = " -ocmrf #{resource.ocmrf_file}"
    command_builder.add "rollback #{source_dir} #{ocmrf} -oh #{oracle_product_home_dir}", :opatchauto
  end
end
