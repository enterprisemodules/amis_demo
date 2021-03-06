newproperty(:table_name) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc <<-EOD
  The table name the synonym references.

		  ora_synonym { 'PUBLIC.SYNONYM_NAME@SID':
		  	...
		    table_name  => 'TABLE_NAME',
		    ...
		  }

  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource.column_data('TABLE_NAME').upcase
  end
end
