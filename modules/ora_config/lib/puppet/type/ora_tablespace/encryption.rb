newparam(:encryption) do
  include EasyType

  desc <<-EOD
    With this parameter you can specify if the tablespace needs
    to be encrypted and/or with what algorythm. When specifying
    a vlue of true, the default encryption algorithm of the
    database will be used.

    ora_tablespace {'my_app_ts@sid':
      ...
      encryption                  => 'true|AES128|AES256|3DES168',
      ...
    }

  EOD

  #defaultto ''

  newvalues(:'AES128', :'AES256', :'3DES168', :true)

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('ENCRYPTIONALG').to_sym
  end

end
