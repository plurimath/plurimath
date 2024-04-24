require "twitter_cldr"

module Plurimath
  class NumberFormatter
    attr_accessor :locale, :localize_number, :twitter_cldr_localiser_symbols

    LOCALIZE_NUMBER_REGEX = %r{(?<group>[^#])?(?<groupdigits>#+0)(?<decimal>.)(?<fractdigits>#+)(?<fractgroup>[^#])?}

    def initialize(locale = "en", localize_number: nil, twitter_cldr_localiser_symbols: {})
      @localize_number = localize_number if localize_number
      @twitter_cldr_localiser_symbols = twitter_cldr_localiser_symbols
      @locale, @twitter_cldr_reader = twitter_cldr_localiser(locale)
    end

    def localized_number(number_string, locale: @locale, precision: nil, digitcount: nil, format: {})
      locale_sym, @reader = locale_and_reader(locale)
      num = BigDecimal(number_string)
      precision ||= /\./.match?(number_string) ? number_string.sub(/^.*\./, "").size : 0
      @reader.merge!(format)
      localize_number(num, locale: locale_sym, precision: precision, digitcount: digitcount.to_i)
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
        .merge!(@twitter_cldr_localiser_symbols)
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

    def localize_number(num, locale:, precision:, digitcount:)
      localized = num.localize(locale)
      return localized.to_s if precision.zero?

      localized.to_decimal.to_s(precision: precision)
    end

    def digitcount_number(number_str, digitcount)
      number = number_str.sub(".", '')
      num_count = number.length
      return number_str if num_count == digitcount
      return round_number(number_str, digitcount) unless (digitcount - num_count).positive?

      zeros = ("0" * (digitcount - num_count))
      number_str += "." unless number_str.include?(".")
      number_str += zeros
      number_str
    end

    def round_number(number, digitcount)
      rounded_number = digitcount - number.split(".").first.length
      return number unless number.include?(".") && rounded_number.positive?

      number.to_f.round(rounded_number).to_s
    end
  end
end
