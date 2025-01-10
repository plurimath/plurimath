# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumericFormatter
      attr_accessor :locale, :localize_number, :localizer_symbols, :twitter_cldr_reader

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
        return send("#{@notation}_format", number_string) if SUPPORTED_NOTATIONS.include?(@notation&.to_sym)

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
        ret = {
          decimal: m[:decimal],
          group_digits: m[:groupdigits].size,
          fraction_group_digits: m[:fractdigits].size,
          group: m[:group] == " " ? "\u00A0" : (m[:group] || ""),
          fraction_group: m[:fractgroup] == " " ? "\u00A0" : (m[:fractgroup]  || "")
        }.compact
      end

      def localize_number(num)
        Formatter::NumberFormatter.new(
          BigDecimal(num),
          @twitter_cldr_reader,
        ).format(
          precision: @precision
        )
      end

      def e_format(num_str)
        notations_formatting(num_str).join(@e.to_s)
      end

      def scientific_format(num_str)
        notations_formatting(num_str).join(" #{@times} 10^")
      end

      def engineering_format(num_str)
        @precision = num_str.length - 1 unless @precision > 0

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
        notation_array = BigDecimal(num_str).to_s("e").split("e")
        notation_array[1] = update_exponent_value(notation_array[1])
        number_str = notation_array[0]
        number_str = number_str.gsub(/0\.(\d)/, '\1.')
        number_str = number_str.sub('.', '') if number_str.start_with?(".")
        notation_array[0] = number_str.end_with?(".") ? number_str[0..-2] : number_str
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
        @precision = update_precision(string, precision)
        @exponent_sign = format[:exponent_sign]&.to_sym || nil
      end

      def update_precision(num, precision)
        return precision if precision
        return num.sub(/\./, "").size - 1 if SUPPORTED_NOTATIONS.include?(@notation&.to_sym)

        /\./.match?(num) ? num.sub(/^.*\./, "").size : 0
      end

      def update_string_index(chars, index)
        return if index.zero?

        chars.first.delete!(".")
        chars.first.insert(index + 1, ".") unless chars.first[index + 2].nil?
        exponent = chars[-1]
        chars[-1] = "#{"+" if exponent.to_s.start_with?("+")}#{exponent.to_i - index}"
      end
    end
  end
end
