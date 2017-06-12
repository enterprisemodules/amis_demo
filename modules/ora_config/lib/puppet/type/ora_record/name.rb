newparam(:name) do
  include EasyType
  include EasyType::Validators::Name

  desc <<-EOD
    A name for the record and the table to manage.

    This can be any name you like.

    Example:

        ora_record { 'just_a_name':
          ...
        }
  EOD

  isnamevar
end
