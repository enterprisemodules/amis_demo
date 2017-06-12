newproperty(:size) do
  include EasyType
  include EasyType::Mungers::Size
  include TablespaceType
  include Puppet_X::EnterpriseModules::Oracle::Access

  desc <<-EOD
    The size of the tablespace.
  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('BYTES').to_i
  end

  def insync?(is)
    if autoextend?
      Puppet.info "#{path}: Puppet ignores the Tablespace[size] attribute when autoextend is on." if different?
      #
      # When autoextend is on, we expect Oracle to manage the size. So we won't do
      # anything with the size attribute when the resource already exists
      #
      true
    else
      #
      # When there is no autoextend on, we just compare the values and pass it to oracle
      #
      is == should
    end
  end

  on_modify do
    sql("alter database #{tablespace_type} '#{resource.provider.datafile}' resize #{value}", :sid => resource.sid)
  end

  on_create do
    if resource[:datafile].nil?
      "#{tablespace_type} size #{resource[:size]}"
    else
      "#{tablespace_type} '#{resource[:datafile]}' size #{resource[:size]}"
    end
  end

  private

  def different?
    current_size != value
  end

  def equal?
    current_size == value
  end

  def current_size
    provider.get(:size)
  end

  def autoextend?
    provider.get(:autoextend) == :on
  end

  def bigfile?
    provider.get(:bigfile) == :yes
  end

  def smallfile?
    !bigfile?
  end
end
