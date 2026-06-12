# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Chooses which precision source wins for one render call.
      class PrecisionResolver
        def resolve(source, precision:, base:, significant:, notation_supported:, digit_count: 0)
          return precision if precision

          significant_precision = significant_base_precision(source, base, significant)
          return significant_precision if significant_precision

          # Source owns input-derived digit lengths; this resolver only decides
          # which precision rule wins. Plain decimal rendering preserves
          # fractional scale, while notation precision controls coefficient
          # digits after the leading digit.
          if notation_supported
            # A requested digit budget (significant or digit_count) widens the
            # coefficient fraction beyond the source's own significant digits
            # (one digit leads, so the fraction allowance is budget - 1).
            budget = [significant, digit_count].max
            return [budget - 1, source.notation_precision].max if budget.positive?

            return source.notation_precision
          end

          source.decimal_precision
        end

        private

        # When precision is omitted, infer the target-base fractional digits
        # needed to satisfy :significant. Cap the count to the source significant
        # digits so base conversion does not invent precision for values like 0.1.
        # Add one extra digit when the source has more significant digits so
        # Significant can still perform the final rounding pass.
        def significant_base_precision(source, base, significant)
          return unless target_base?(base)

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
          BaseNotation::DEFAULT_PREFIXES.key?(base) && base != Base::DEFAULT_BASE
        end
      end
    end
  end
end
