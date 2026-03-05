# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Integer < Base
        attr_reader :separator, :groups

        DEFAULT_SEPARATOR = ","

        def initialize(symbols = {})
          super
          @groups    = symbols[:group_digits] || 3
          @separator = symbols[:group] || DEFAULT_SEPARATOR
        end

        def apply(number)
          based_number = number_to_base(number)
          based_number = based_number.upcase if upcase_hex?
          format_groups(based_number)
        end

        def format_groups(string)
          tokens = []

          until string.empty?
            tokens << chop_group(string, groups)
            string = string[0...-tokens.last.size]
          end

          tokens.compact.reverse.join(separator)
        end

        def chop_group(string, size)
          string.slice([string.size - size, 0].max, size)
        end

        def number_to_base(number)
          return number if base_default?

          number.to_i.to_s(base)
        end
      end
    end
  end
end
