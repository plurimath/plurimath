# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Converts integer digits to the target base and applies integer grouping.
      class Integer < Base
        attr_reader :separator, :groups, :padding, :padding_digits,
                    :padding_group_digits

        def initialize(options)
          super
          @groups = self.options.group_digits
          @separator = self.options.group
          @padding = self.options.padding
          @padding_digits = self.options.padding_digits
          @padding_group_digits = self.options.padding_group_digits
        end

        def apply(number)
          format_groups(number_to_base(number))
        end

        def format_groups(string)
          string = capitalize_hex_digits(string)
          string = pad_integer(string)
          # group_digits: 0 disables grouping, mirroring fraction grouping.
          return string unless groups.positive?

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

        private

        def pad_integer(string)
          target_width = padding_target_width(string)
          return string unless target_width > string.length

          string.rjust(target_width, padding)
        end

        def padding_target_width(string)
          return padding_digits if padding_digits.positive?
          return string.length unless padding_group_digits.positive?

          remainder = string.length % padding_group_digits
          return string.length if remainder.zero?

          string.length + padding_group_digits - remainder
        end
      end
    end
  end
end
