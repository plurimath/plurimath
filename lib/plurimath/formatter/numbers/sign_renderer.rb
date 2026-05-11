# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class SignRenderer
        def initialize(options)
          @options = FormatOptions.coerce(options)
        end

        def apply(number, rendered)
          "#{prefix(number)}#{rendered}"
        end

        private

        attr_reader :options

        def prefix(number)
          return "-" if number.negative?

          "+" if options.number_sign&.to_sym == :plus
        end
      end
    end
  end
end
