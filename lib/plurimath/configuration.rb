# frozen_string_literal: true

module Plurimath
  class Configuration
    DEFAULT_DECIMAL = "."

    attr_accessor :number_formatter, :locale

    def deprecation
      Deprecation
    end

    def decimal
      Formatter::SupportedLocales.decimal_for(locale, default: DEFAULT_DECIMAL)
    end
  end
end
