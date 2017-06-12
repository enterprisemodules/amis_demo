newparam(:parameter_name) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase

  desc <<-EOD
    The parameter name.
  EOD

  isnamevar

end
