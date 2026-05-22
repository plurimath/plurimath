# frozen_string_literal: true

module Plurimath
  class Configuration
    DEFAULT_DECIMAL = "."

    attr_accessor :number_formatter, :locale

    def deprecation
      Deprecation
    end

    def decimal
      Formatter::SupportedLocales::LOCALES
        .fetch(locale_key, {})
        .fetch(:decimal, DEFAULT_DECIMAL)
    end

    private

    def locale_key
      locale.respond_to?(:to_sym) ? locale.to_sym : locale
    end
  end
end
