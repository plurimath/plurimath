# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Integer
        attr_reader :format, :separator, :groups

        def initialize(symbols = {})
          @groups    = Array(symbols[:group_digits] || 3)
          @separator = symbols[:group] || ','
        end

        def apply(number, options = {})
          format_groups(number)
        end

        def format_groups(string)
          return string if groups.empty?

          tokens = []

          tokens << chop_group(string, groups.first)
          string = string[0...-tokens.first.size]

          until string.empty?
            tokens << chop_group(string, groups.last)
            string = string[0...-tokens.last.size]
          end

          tokens.compact.reverse.join(separator)
        end

        def chop_group(string, size)
          string.slice([string.size - size, 0].max, size)
        end
      end
    end
  end
end
