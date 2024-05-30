require "twitter_cldr"
require_relative "numbers/integer"
require_relative "numbers/fraction"
require_relative "number_formatter"
require_relative "number_data_reader"
require_relative "localized_number"

module Plurimath
  module Formatter
    class NumericFormatter
      attr_accessor :locale, :localize_number, :localizer_symbols

      LOCALIZE_NUMBER_REGEX = %r{(?<group>[^#])?(?<groupdigits>#+0)(?<decimal>.)(?<fractdigits>#+)(?<fractgroup>[^#])?}
      SUPPORTED_NOTATIONS = %i[e scientific engineering].freeze

      def initialize(locale, localize_number:, localizer_symbols:)
        @locale = locale
        @localize_number = localize_number
        @localizer_symbols = localizer_symbols
        @twitter_cldr_reader = twitter_cldr_reader
      end

      def localized_number(number_string, locale:, precision:, format:)
        options_instance_variables(number_string, format, precision)
        @twitter_cldr_reader.merge!(format)
        return send("#{@notation}_format", number_string) if SUPPORTED_NOTATIONS.include?(@notation&.to_sym)

        localize_number(number_string)
      end

      private

      def twitter_cldr_reader
        num = TwitterCldr::DataReaders::NumberDataReader.new(locale)
        num.symbols
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
        num = num.match?(/\./) ? num.to_f : num.to_i
        localized = localize(BigDecimal(num.to_s))
        return localized.to_s if @precision.zero?

        localized.to_decimal.to_s(precision: @precision)
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

      def update_exponent_sign(str)
        str.gsub!("e", "e+") if @exponent_sign == :plus
      end

      def notation_chars(num_str)
        notation_number = ("%.#{@precision}e" %num_str)
        update_exponent_sign(notation_number.gsub!("+0", ""))
        notation_number.split("e")
      end

      def notations_formatting(num_str)
        chars = notation_chars(num_str)
        chars[0] = localize_number(chars[0])
        chars
      end

      def options_instance_variables(string, format, precision)
        @e = format.delete(:e)&.to_sym || :e
        @times = format.delete(:times)&.to_sym || "\u{d7}"
        @notation = format.delete(:notation)&.to_sym || nil
        @precision = update_precision(string, precision)
        @exponent_sign = format.delete(:exponent_sign)&.to_sym || nil
      end

      def update_precision(num, precision)
        return precision if precision
        return num.sub(/\./, "").size - 1 if SUPPORTED_NOTATIONS.include?(@notation&.to_sym)

        /\./.match?(num) ? num.sub(/^.*\./, "").size : 0
      end

      def update_string_index(chars, index)
        return if index.zero?

        chars.first.delete!(".")
        chars.first.insert(index + 1, ".")
        chars[-1] = (chars[-1].to_i - index).to_s
      end

      def localize(value)
        LocalizedNumber.new(value, @locale, type: :decimal)
      end
    end
  end
end
