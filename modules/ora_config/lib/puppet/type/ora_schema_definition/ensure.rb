newproperty(:ensure) do
  include EasyType

  desc <<-EOD
    version number or the literal `latest`.

    This property allows you to specify the version of the schema you want to have loaded.

    Here is an example on how you can use this:

          ora_schema_definition{ 'myapp@sid:
            ...
            password => 'secret',
            ensure   => '2.2.1',
            ...
          }

    In layman's terms now the following things will happen:

    - The Puppet type will log in to the database using username `myapp` and the very secret password and it will look at the version of the schema already available.
    - If the current version is lower than the specified version, Puppet will execute the upgrade SQL scripts in the source path until the correct version is reached.
    - If the current version is higher than the requested version, Puppet will execute the downgrade scripts until the requested version is reached.

    The version number *MUST* be a string containing 3 point characters separating the major, minor and patch number:

    `major.minor.patch`

    You can also specify the term `latest`. In that case, Puppet will look in the `source_pad` see what the
    highest available version is and ensure that version of the schema is available in the database.

    Here is an example on how you can use this:

          ora_schema_definition{ 'my_app@sid:
            ...
            ensure => 'latest',
            ...
          }


  EOD

  newvalue(:absent) do
    @resource.provider.destroy
  end
  newvalue(:latest)
  newvalue(/^\d{1,3}.\d{1,3}.\d{1,3}$/)
  aliasvalue(:present, :latest)

  defaultto(:latest)

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('VERSION')
  end
end
