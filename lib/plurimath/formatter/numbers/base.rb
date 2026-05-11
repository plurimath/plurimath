# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Base
        HEX_ALPHANUMERIC = %w[0 1 2 3 4 5 6 7 8 9 a b c d e f].freeze
        DEFAULT_BASE = 10
        DIGIT_VALUE = HEX_ALPHANUMERIC.each_with_index.to_h

        attr_accessor :base, :symbols

        def initialize(symbols = {})
          @symbols = symbols
          @base = symbols[:base] || DEFAULT_BASE
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

        def digit_sequence
          @digit_sequence ||= DigitSequence.new(base: base)
        end
      end
    end
  end
end
