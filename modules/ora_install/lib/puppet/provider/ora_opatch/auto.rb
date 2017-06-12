require 'easy_type'

Puppet::Type.type(:ora_opatch).provide(:auto, :parent => :base) do
  def self.instances
    []
  end

  def context
    "export ORACLE_HOME=#{oracle_product_home_dir}; cd #{oracle_product_home_dir}; "
  end

  def apply_patch(source_dir, command_builder)
    ocmrf = " -ocmrf #{resource.ocmrf_file}"
    command_builder.add "auto #{source_dir} #{ocmrf} -oh #{oracle_product_home_dir}", :uid => 'root'
  end

  def remove_patch(source_dir, command_builder)
    command_builder.add "auto -rollback #{source_dir} #{ocmrf} -oh #{oracle_product_home_dir}", :uid => 'root'
  end
end
