newparam(:owner) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
	The owner of the table you want to audit. This is the first part of the title string. The first part before
	the `.`.

      ora_object_audit { 'OWNER.TABLE@SID':
      	...
      }


	EOD

  isnamevar
end
