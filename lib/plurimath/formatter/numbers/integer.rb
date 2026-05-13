# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Converts integer digits to the target base and applies integer grouping.
      class Integer < Base
        attr_reader :separator, :groups

        def initialize(options)
          super
          @groups = self.options.group_digits
          @separator = self.options.group
        end

        def apply(number)
          format_groups(number_to_base(number))
        end

        def format_groups(string)
          string = capitalize_hex_digits(string)
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
