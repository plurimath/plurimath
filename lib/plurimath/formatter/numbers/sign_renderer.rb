# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class SignRenderer
        def initialize(number_sign)
          @number_sign = number_sign
        end

        def apply(number, rendered)
          "#{prefix(number)}#{rendered}"
        end

        private

        attr_reader :number_sign

        def prefix(number)
          return "-" if number.negative?

          "+" if number_sign&.to_sym == :plus
        end
      end
    end
  end
end
