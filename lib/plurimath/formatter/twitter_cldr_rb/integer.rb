# frozen_string_literal: true

module TwitterCldr
  module Formatters
    module Numbers
      class Integer
        def initialize(token, symbols = {})
          format     = token.value.split('.')[0]
          @format    = prepare_format(format, symbols)
          @groups    = Array(symbols[:group_digits] || parse_groups(format))
          @separator = symbols[:group] || ','
        end
      end
    end
  end
end
