newparam(:username) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  defaultto ''

  desc <<-EOD
    The owner of the table.

    If none is specfied, it will connect as the user specified in ora_setting.
  EOD
end
