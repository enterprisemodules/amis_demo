# encoding: UTF-8
#
#
# Define all common insync? methods
#
module EasyType
  #
  # The Integer munger, munges a specified value to an Integer.
  #
  module Syncers
    # Doc
    module CaseInsensitive
      # @private
      def insync?(is)
        if is == :absent
          should.nil?
        elsif should == :absent
          is.nil?
        else
          should.casecmp(is) == 0 ? true : false
        end
      end
    end
  end
end
