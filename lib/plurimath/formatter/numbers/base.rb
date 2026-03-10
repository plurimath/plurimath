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
          @threshold ||= base.div(2)
        end

        def base_default?
          base == DEFAULT_BASE
        end

        def next_mapping_char(char)
          current_idx = DIGIT_VALUE[char]
          return nil unless current_idx

          HEX_ALPHANUMERIC[current_idx + 1]
        end
      end
    end
  end
end
