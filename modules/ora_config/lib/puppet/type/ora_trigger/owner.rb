newparam(:owner) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
	The owner of the package. This is the first part of the title string. The first part before
	the `.`.

      ora_trigger { 'OWNER.TRIGGER@SID':
      	...
      }
	EOD

  isnamevar
end
