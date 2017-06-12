newparam(:create_only, :array_matching => :all) do
  include EasyType

  defaultto []

  validate do |value|
    fail 'You need to specify an Array instead of a comma separated string' if value =~ /,/
  end

  desc <<-EOD
    The attributes from `ora_user` you only want to manage when you create a user.
    This is usefull when defining oracle iser accounts for REAL users. Users that
    are supposed to change the password and the account expirery.
    Here is an example:

        ora_user {'scott':
          password    => 'secret',
          locked      => false,
          expired     => true,
          create_only => ['locked', 'expired', 'password']
        }

    When user `scott` doesn't exists, it will be created as an expired account,
    with specfied password. After the first run the properties `locked` `expired`
    and `password` are not updated anymore. Even when there is a difference between
    the manifest and reality.

  EOD
end
