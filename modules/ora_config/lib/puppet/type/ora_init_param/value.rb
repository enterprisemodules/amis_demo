# rubocop: disable Metrics/BlockLength
newproperty(:value, :array_matching => :all) do
  include EasyType
  include EasyType::Mungers::String
  include Puppet_X::EnterpriseModules::Oracle::Access
  #
  # Aslways convert the values to a string representation here. In the routine specified_value of the type,
  # it will be converted to the actual representation.
  #

  desc <<-EOD
    The value or values of the parameter.

    You can use either a single value or an Array value. Although not strictly required, we
    reccomend that you alsways use quoted values. Also when using nummeric or boolean values.


    An example  using a boolean value:

        ora_init_param { ....:
          ...
          value  => 'FALSE',
        }

    Here an example using an array of values:

        ora_init_param { ....:
          ...
          value  => ['RECODG', 'BACKUPDG', 'DATADG'],
        }

        ora_init_param { ...:
          ...
          value  => '1',
        }
  EOD

  #
  # Order doesn't matter
  #
  def insync?(is)
    is = [] if is == :absent || is.nil?
    Array(is).sort == Array(should).sort
  end

  to_translate_to_resource do |raw_resource|
    value = raw_resource.column_data('DISPLAY_VALUE')
    value.is_a?(::Array) ? value.collect { |e| hex_to_raw(e) } : hex_to_raw(value)
  end

end
