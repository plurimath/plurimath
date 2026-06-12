# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Applies the final sign prefix to already-rendered number text.
      class SignRenderer
        def initialize(positive_sign = nil)
          @positive_sign = positive_sign
        end

        def apply(number, rendered)
          "#{prefix(number)}#{rendered}"
        end

        private

        attr_reader :positive_sign

        def prefix(number)
          return "-" if number.negative?

          # FormatOptions delivers a normalized Symbol (or nil) here.
          "+" if positive_sign == :plus
        end
      end
    end
  end
end
