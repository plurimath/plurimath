# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Shared base for formatter helpers that need resolved options, target
      # base state, and common digit operations.
      class Base
        HEX_DIGITS = "abcdef"
        HEX_ALPHANUMERIC = %w[0 1 2 3 4 5 6 7 8 9 a b c d e f].freeze
        DEFAULT_BASE = 10
        DIGIT_VALUE = HEX_ALPHANUMERIC.each_with_index.to_h

        attr_accessor :base, :options

        def initialize(options)
          @options = options
          @base = @options.base
        end

        protected

        def threshold
          digit_sequence.threshold
        end

        def base_default?
          base == DEFAULT_BASE
        end

        def next_mapping_char(char)
          digit_sequence.next_digit(char)
        end

        def capitalize_hex_digits(string)
          return string unless base == 16 && options.hex_capital == :numbers_only

          string.tr(HEX_DIGITS, HEX_DIGITS.upcase)
        end

        def digit_sequence
          @digit_sequence ||= DigitSequence.new(base: base)
        end
      end
    end
  end
end
