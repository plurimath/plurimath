require "twitter_cldr"
require_relative "twitter_cldr_rb/fraction"
require_relative "twitter_cldr_rb/number_formatter"

module Plurimath
  module Formatter
    class NumberFormatter
      attr_accessor :locale, :localize_number, :localiser_symbols

      LOCALIZE_NUMBER_REGEX = %r{(?<group>[^#])?(?<groupdigits>#+0)(?<decimal>.)(?<fractdigits>#+)(?<fractgroup>[^#])?}
      SUPPORTED_NOTATIONS = %i[basic scientific engineering e].freeze

      def initialize(locale = "en", localize_number: nil, localiser_symbols: {})
        @localize_number = localize_number if localize_number
        @localiser_symbols = localiser_symbols
        @locale, @twitter_cldr_reader = twitter_cldr_localiser(locale)
      end

      def localized_number(number_string, locale: @locale, precision: nil, format: {})
        locale_sym, @reader = locale_and_reader(locale)
        num = BigDecimal(number_string)
        precision ||= /\./.match?(number_string) ? number_string.sub(/^.*\./, "").size : 0
        @reader.merge!(format)
        if format[:notation] && format[:notation] != :basic
          send("#{format[:notation]}_format", num.to_s, locale: locale_sym, precision: precision)
        else
          localize_number(num, locale: locale_sym, precision: precision)
        end
      end

      private

      def twitter_cldr_localiser(locale = "en")
        locale = TwitterCldr.supported_locale?(locale.to_sym) ? locale.to_sym : :en
        [locale , twitter_cldr_reader(locale)]
      end

      def twitter_cldr_reader(locale)
        return @twitter_cldr_reader if locale.to_s == @locale.to_s && @twitter_cldr_reader

        num = TwitterCldr::DataReaders::NumberDataReader.new(locale)
        num.symbols
          .merge!(@localiser_symbols)
          .merge!(parse_localize_number)
      end

      def parse_localize_number
        @localize_number or return {}
        m = LOCALIZE_NUMBER_REGEX.match(@localize_number) or return {}
        ret = { decimal: m[:decimal], group_digits: m[:groupdigits].size,
                fraction_group_digits: m[:fractdigits].size,
                group: m[:group] || "",
                fraction_group: m[:fractgroup] || "" }.compact
        %i(group fraction_group).each { |x| ret[x] == " " and ret[x] = "\u00A0" }
        ret
      end

      def locale_and_reader(locale)
        if (locale.to_s == @locale.to_s)
          [@locale,  @twitter_cldr_reader]
        else
          twitter_cldr_localiser(locale)
        end
      end

      def localize_number(num, locale:, precision:)
        localized = num.localize(locale)
        return localized.to_s if precision.zero?

        localized.to_decimal.to_s(precision: precision)
      end

      def e_format(num_str, locale:, precision:)
        localized, exponent = notation_format(num_str, locale, precision)
        "#{localized}#{@reader&.dig(:e) || :e}#{exponent_sign}#{exponent}"
      end

      def exponent_sign
        "+" if @reader&.dig(:exponent_sign)&.to_sym == :plus
      end

      def notation_format(num_str, locale, precision)
        num_str = num_str&.sub!(/0\./, "")&.insert(1, ".")
        chars = num_str.chars
        chars.last.replace((chars.last.to_i - 1).to_s)
        big_decimal = BigDecimal(chars.join.split("e").first)
        localized = localize_number(big_decimal, locale: locale, precision: precision)
        [localized, chars.slice_after("e").to_a.last.join]
      end
    end
  end
end
