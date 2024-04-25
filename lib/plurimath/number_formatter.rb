require "plurimath/formatter/number_formatter"

module Plurimath
  class NumberFormatter
    attr_accessor :locale, :localize_number, :localiser_symbols

    def initialize(locale = "en", localize_number: nil, localiser_symbols: {})
      @locale = supported_locale(locale)
      @localize_number = localize_number if localize_number
      @localiser_symbols = localiser_symbols
    end

    def localized_number(number_string, locale: @locale, precision: nil, format: {})
      Formatter::NumberFormatter.new(
        locale,
        localize_number: localize_number,
        localiser_symbols: localiser_symbols,
      ).localized_number(
        number_string,
        locale: locale,
        precision: precision,
        format: format,
      )
    end

    private

    def supported_locale(locale)
      TwitterCldr.supported_locale?(locale.to_sym) ? locale.to_sym : :en
    end
  end
end
