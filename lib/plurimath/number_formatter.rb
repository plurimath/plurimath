require "plurimath/formatter/numeric_formatter"

module Plurimath
  class NumberFormatter
    attr_accessor :locale, :localize_number, :localizer_symbols

    def initialize(locale = "en", localize_number: nil, localizer_symbols: {})
      @locale = supported_locale(locale)
      @localize_number = localize_number
      @localizer_symbols = localizer_symbols
    end

    def localized_number(number_string, locale: @locale, precision: nil, format: {})
      Formatter::NumericFormatter.new(
        supported_locale(locale),
        localize_number: localize_number,
        localizer_symbols: localizer_symbols,
      ).localized_number(
        number_string,
        locale: supported_locale(locale),
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
