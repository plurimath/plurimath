# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class PrecisionResolver
        SUPPORTED_NOTATIONS = NotationRenderer::SUPPORTED_NOTATIONS

        def resolve(number_string, precision:, format:, notation:)
          return precision if precision

          significant_precision = significant_base_precision(number_string, format)
          return significant_precision if significant_precision

          return notation_precision(number_string) if supported_notation?(notation)

          decimal_precision(number_string)
        end

        private

        def decimal_precision(number_string)
          number_string.include?(".") ? number_string.sub(/^.*\./, "").size : 0
        end

        def notation_precision(number_string)
          number_string.sub(".", "").size - 1
        end

        def supported_notation?(notation)
          SUPPORTED_NOTATIONS.include?(notation&.to_sym)
        end

        # When precision is omitted, infer the target-base fractional digits
        # needed to satisfy :significant. Cap the count to the source significant
        # digits so base conversion does not invent precision for values like 0.1.
        # Add one extra digit when the source has more significant digits so
        # Significant can still perform the final rounding pass.
        def significant_base_precision(number_string, format)
          source = Source.new(number_string)
          base = format[:base] || Formatter::NumberFormatter::DEFAULT_BASE
          return unless target_base?(base)

          significant = format[:significant].to_i
          return if significant.zero?

          return 0 unless source.fractional?

          source_significant = source.significant_digit_count
          effective_significant = [significant, source_significant].min
          target_precision = [
            effective_significant - source.target_base_integer_length(base),
            0,
          ].max

          target_precision += 1 if source_significant > effective_significant
          target_precision
        end

        def target_base?(base)
          Formatter::NumberFormatter::DEFAULT_BASE_PREFIXES.key?(base) &&
            base != Formatter::NumberFormatter::DEFAULT_BASE
        end
      end
    end
  end
end
