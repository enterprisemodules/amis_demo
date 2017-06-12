newproperty(:table_owner) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
  The table owner the synonym references.

		  ora_synonym { 'PUBLIC.SYNONYM_NAME@SID':
		  	...
		    table_owner  => 'TABLE_OWNER',
		    ...
		  }
  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('TABLE_OWNER')
  end
end
