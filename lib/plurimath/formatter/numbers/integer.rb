# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Integer < Base
        attr_reader :format, :separator, :groups

        def initialize(token, symbols = {})
          format     = token.to_s("F").split('.')[0]
          @format    = prepare_format(format, symbols)
          @groups    = Array(symbols[:group_digits] || parse_groups(format) || 3)
          @separator = symbols[:group] || ','
        end

        def apply(number, options = {})
          format_groups(interpolate(format, number.to_i))
        end

        def format_groups(string)
          return string if groups.empty?

          tokens = []

          tokens << chop_group(string, groups.first)
          tokens << chop_group(string, groups.last) until string.empty?

          tokens.compact.reverse.join(separator)
        end

        def parse_groups(format)
          return unless index = format.rindex(',')

          rest   = format[0, index]
          widths = [format.size - index - 1]
          widths << rest.size - rest.rindex(',') - 1 if rest.rindex(',')
          widths.compact.uniq
        end

        def chop_group(string, size)
          string.slice!([string.size - size, 0].max, size)
        end

        def prepare_format(format, symbols)
          signs = symbols.values_at(:plus_sign, :minus_sign)
          format.tr(',', '').tr('+-', signs.join)
        end
      end
    end
  end
end
