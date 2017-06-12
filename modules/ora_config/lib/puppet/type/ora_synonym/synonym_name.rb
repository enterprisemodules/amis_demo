newparam(:synonym_name) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
	The synonym name. This is the part of the title between the `.` and the `@`

		  ora_synonym { 'PUBLIC.SYNONYM_NAME@SID':
		  	...
		  }

  EOD

  isnamevar
end
