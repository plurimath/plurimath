# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumericFormatter
      attr_accessor :locale, :localize_number, :localizer_symbols,
                    :twitter_cldr_reader

      LOCALIZE_NUMBER_REGEX = %r{(?<group>[^#])?(?<groupdigits>#+0)(?<decimal>.)(?<fractdigits>#+)(?<fractgroup>[^#])?}
      SUPPORTED_NOTATIONS = Numbers::NotationRenderer::SUPPORTED_NOTATIONS

      def initialize(locale, localize_number:, localizer_symbols:)
        @locale = locale
        @localize_number = localize_number
        @localizer_symbols = localizer_symbols
        @twitter_cldr_reader = twitter_cldr_reader_lookup
      end

      def localized_number(number_string, locale:, precision:, format:)
        options_instance_variables(number_string, format, precision)
        @twitter_cldr_reader.merge!(format)
        if SUPPORTED_NOTATIONS.include?(@notation&.to_sym)
          return notation_renderer.render(number_string, @notation)
        end

        localize_number(number_string)
      end

      private

      def twitter_cldr_reader_lookup
        symbols = Formatter::SupportedLocales::LOCALES[locale.to_sym]
        symbols
          .merge!(@localizer_symbols)
          .merge!(parse_localize_number)
      end

      def parse_localize_number
        @localize_number or return {}
        m = LOCALIZE_NUMBER_REGEX.match(@localize_number) or return {}
        {
          decimal: m[:decimal],
          group_digits: m[:groupdigits].size,
          fraction_group_digits: m[:fractdigits].size,
          group: m[:group] == " " ? "\u00A0" : (m[:group] || ""),
          fraction_group: m[:fractgroup] == " " ? "\u00A0" : (m[:fractgroup] || ""),
        }.compact
      end

      def localize_number(num)
        Formatter::NumberFormatter.new(
          BigDecimal(num),
          @twitter_cldr_reader,
        ).format(
          precision: @precision,
        )
      end

      def notation_renderer
        Numbers::NotationRenderer.new(
          @twitter_cldr_reader,
          precision: @precision,
          exponent_sign: @exponent_sign,
          exponent_separator: @e,
          times: @times,
        )
      end

      def options_instance_variables(string, format, precision)
        @e = format[:e]&.to_sym || :e
        @times = format[:times]&.to_sym || "\u{d7}"
        @notation = format[:notation]&.to_sym || nil
        @precision = update_precision(string, precision, format)
        @exponent_sign = format[:exponent_sign]&.to_sym || nil
      end

      def update_precision(num, precision, format)
        return precision if precision

        significant_precision = significant_base_precision(num, format)
        return significant_precision if significant_precision

        if SUPPORTED_NOTATIONS.include?(@notation&.to_sym)
          return num.sub(".",
                         "").size - 1
        end

        num.include?(".") ? num.sub(/^.*\./, "").size : 0
      end

      # When precision is omitted, infer the target-base fractional digits
      # needed to satisfy :significant. Cap the count to the source significant
      # digits so base conversion does not invent precision for values like 0.1.
      # Add one extra digit when the source has more significant digits so
      # Significant can still perform the final rounding pass.
      def significant_base_precision(num, format)
        source = Numbers::Source.new(num)
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
