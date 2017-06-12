module Puppet_X
  module EnterpriseModules
    module Oracle
      # Docs
      module Utilities
        def self.included(parent)
          parent.extend(Utilities)
        end

        #
        # Generate a valid Oracle password
        #
        def generated_password(length = 12)
          fail "Request password length is #{length}, but needs to be at least 9" if length < 9
          resulting_length = length - 9
          random_letter +
            (random_character(resulting_length) +
             random_special_character(2) +
             random_uppercase(2) +
             random_lowercase(2) +
             random_digit(2)).chars.sort_by { rand }.join
        end

        # @private
        def random_letter(length = 1)
          (('A'..'Z').to_a + ('a'..'z').to_a).sort_by { rand }.join[0...length]
        end

        # @private
        def random_special_character(length = 1)
          '!@#$%^*()_+{}|:>?<[]\\;,.~'.chars.sort_by { rand }.join[0...length]
        end

        # @private
        def random_uppercase(length = 1)
          ('A'..'Z').to_a.sort_by { rand }.join[0...length]
        end

        # @private
        def random_lowercase(length = 1)
          ('a'..'z').to_a.sort_by { rand }.join[0...length]
        end

        # @private
        def random_digit(length = 1)
          ('0'..'9').to_a.sort_by { rand }.join[0...length]
        end

        # @private
        def random_character(length = 1)
          (('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a).sort_by { rand }.join[0...length]
        end
      end
    end
  end
end
