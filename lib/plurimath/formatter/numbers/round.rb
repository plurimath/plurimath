# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      module Round
        DEFAULT_BASE = 10
        HEX_ALPHANUMERIC = %w[0 1 2 3 4 5 6 7 8 9 a b c d e f]
        DIGIT_VALUE = HEX_ALPHANUMERIC.each_with_index.to_h

        def threshold
          base.div(2)
        end
      end
    end
  end
end
