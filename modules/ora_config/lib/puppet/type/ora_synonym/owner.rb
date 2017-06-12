newparam(:owner) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
  	The owner of the synonym. This is the first part of the title string. The first part before
  	the `.`.

        ora_synonym { 'OWNER.SYNONYM_NAME@SID':
        	...
        }


	EOD

  isnamevar
end
