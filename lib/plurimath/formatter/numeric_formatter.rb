# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumericFormatter
      attr_accessor :locale, :localize_number, :localizer_symbols,
                    :twitter_cldr_reader

      LOCALIZE_NUMBER_REGEX = %r{(?<group>[^#])?(?<groupdigits>#+0)(?<decimal>.)(?<fractdigits>#+)(?<fractgroup>[^#])?}
      SUPPORTED_NOTATIONS = %i[e scientific engineering].freeze

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
          return send("#{@notation}_format",
                      number_string)
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

      def e_format(num_str)
        notations_formatting(num_str).join(@e.to_s)
      end

      def scientific_format(num_str)
        notations_formatting(num_str).join(" #{@times} 10^")
      end

      def engineering_format(num_str)
        @precision = num_str.length - 1 unless @precision.positive?

        chars = notation_chars(num_str)
        update_string_index(chars, chars.last.to_i % 3)
        chars[0] = localize_number(chars[0])
        chars.join(" #{@times} 10^")
      end

      def update_exponent_value(number_str)
        exponent_number = BigDecimal(number_str) - 1
        return exponent_number.to_i if exponent_number.negative? || @exponent_sign.to_s != "plus"

        "+#{exponent_number.to_i}"
      end

      def notation_chars(num_str)
        bd = BigDecimal(num_str)
        return [num_str, 0] if bd.zero?

        notation_array = bd.to_s("e").split("e")
        notation_array[1] = update_exponent_value(notation_array[1])
        number_str = notation_array[0]
        number_str = number_str.gsub(/0\.(\d)/, '\1.')
        number_str = number_str.sub(".", "") if number_str.start_with?(".")
        notation_array[0] =
          number_str.end_with?(".") ? number_str[0..-2] : number_str
        notation_array
      end

      def notations_formatting(num_str)
        chars = notation_chars(num_str)
        chars[0] = localize_number(chars[0])
        chars << "0" if chars.length == 1
        chars
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
      def significant_base_precision(num, format)
        base = format[:base] || Formatter::NumberFormatter::DEFAULT_BASE
        return unless target_base?(base)

        significant = format[:significant].to_i
        return if significant.zero?

        decimal_precision = source_fractional_digits(num)
        return 0 if decimal_precision.zero?

        effective_significant = [
          significant,
          source_significant_digits(num),
        ].min
        target_precision = [
          effective_significant - target_base_integer_length(num, base),
          0,
        ].max

        [decimal_precision, target_precision].max
      end

      def target_base?(base)
        Formatter::NumberFormatter::DEFAULT_BASE_PREFIXES.key?(base) &&
          base != Formatter::NumberFormatter::DEFAULT_BASE
      end

      def source_fractional_digits(num)
        mantissa, exponent = num.to_s.downcase.split("e", 2)
        fraction_length = mantissa.split(".", 2)[1].to_s.length

        [fraction_length - exponent.to_i, 0].max
      end

      def source_significant_digits(num)
        mantissa = num.to_s.downcase.split("e", 2).first
        mantissa.sub(/\A[-+]/, "").delete(".").sub(/\A0+/, "").length
      end

      def target_base_integer_length(num, base)
        integer = BigDecimal(num).abs.to_i
        return 0 if integer.zero?

        integer.to_s(base).length
      end

      def update_string_index(chars, index)
        return if index.zero?

        chars.first.delete!(".")
        chars.first.insert(index + 1, ".") unless chars.first[index + 2].nil?
        exponent = chars[-1]
        chars[-1] =
          "#{'+' if exponent.to_s.start_with?('+')}#{exponent.to_i - index}"
      end
    end
  end
end
