require 'pathname'

newparam(:ocmrf_file) do
  desc <<-EOT
    The ocmrf file.

    Valid values are:
    - absent   (No ocmrf file is passed to opatch)
    - standard (A standard ocmrf file is provided)
    - a file name specification

  EOT

  defaultto :absent
end

def ocmrf_file
  case self[:ocmrf_file]
  when 'standard', nil
    (Pathname.new(__FILE__).dirname.parent.parent + 'provider' + 'ora_opatch' + 'ocm.rsp').to_s
  when :absent, 'absent'
    nil
  else
    self[:ocmrf_file]
  end
end
