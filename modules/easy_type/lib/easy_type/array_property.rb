# rubocop: disable Metrics/AbcSize

module EasyType
  #
  # Includes all behaviour needed for an Array property
  #
  module ArrayProperty
    def unsafe_validate(value)
      raise 'You need to specify an Array instead of a comma separated string' if value =~ /,/
    end

    def insync?(is)
      if is == :absent
        should.empty?
      elsif should == :absent
        is.empty?
      else
        is.sort == should.sort
      end
    end

    #
    # Print a good change message when chaning the contents of an array
    #
    def change_to_s(current, should)
      current = [] if current == :absent
      should = [] if should == :absent
      message = ''
      unless (current - should).inspect == '[]'
        message << "removing #{(current - should).join(', ')} "
      end
      unless (should - current).inspect == '[]'
        message << "adding #{(should - current).join(', ')} "
      end
      #
      # If the array contains the same value twice e.g.  compare ['Server','Server'],
      # the current algorithm returns an empty string. In that case we use the full value.
      #
      message = "changed to #{should}" if message.empty?
      message
    end
  end
end
