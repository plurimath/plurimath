# frozen_string_literal: true

require "bigdecimal"

module Plurimath
  class NumberFormatter
    attr_accessor :locale, :localize_number, :localizer_symbols, :precision

    def initialize(locale = "en", localize_number: nil, localizer_symbols: {},
precision: nil)
      @locale = supported_locale(locale)
      @localize_number = localize_number
      @localizer_symbols = localizer_symbols
      @precision = precision
    end

    def localized_number(number_string, locale: @locale, precision: @precision,
format: {})
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

    def twitter_cldr_reader(locale: @locale)
      Formatter::NumericFormatter.new(
        supported_locale(locale),
        localize_number: localize_number,
        localizer_symbols: localizer_symbols,
      ).twitter_cldr_reader
    end

    private

    def supported_locale(locale)
      Formatter::SupportedLocales::LOCALES.key?(locale.to_sym) ? locale.to_sym : :en
    end
  end
end
