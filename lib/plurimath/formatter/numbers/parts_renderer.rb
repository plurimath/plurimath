# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Renders already-transformed Parts into localized integer/fraction text.
      class PartsRenderer
        def initialize(integer_formatter:, fraction_formatter:)
          @integer_formatter = integer_formatter
          @fraction_formatter = fraction_formatter
        end

        def render(parts)
          rendered = integer_formatter.format_groups(parts.integer_digits)
          return rendered unless parts.fractional?

          "#{rendered}#{fraction_formatter.decimal}#{formatted_fraction(parts)}"
        end

        private

        attr_reader :fraction_formatter, :integer_formatter

        def formatted_fraction(parts)
          fraction_formatter.format_groups(parts.fraction_digits)
        end
      end
    end
  end
end
