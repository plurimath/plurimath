# frozen_string_literal: true

module Plurimath
  class Configuration
    DEFAULT_DECIMAL = "."

    attr_accessor :number_formatter
    attr_writer :locale

    def deprecation
      Deprecation
    end

    def locale
      @locale || number_formatter_locale
    end

    def decimal
      locale_symbols.fetch(:decimal, DEFAULT_DECIMAL)
    end

    private

    def locale_symbols
      Formatter::SupportedLocales::LOCALES.fetch(locale_key, {})
    end

    def locale_key
      locale.respond_to?(:to_sym) ? locale.to_sym : locale
    end

    def number_formatter_locale
      number_formatter.locale if number_formatter.respond_to?(:locale)
    end
  end
end
