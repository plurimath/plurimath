# frozen_string_literal: true

module Plurimath
  module Errors
    class UnsupportedLocale < Plurimath::Error
      def initialize(locale, supported_locales)
        @locale = locale
        @supported = supported_locales.map(&:inspect).join(", ")
        super(message)
      end

      def message
        "[plurimath] Unsupported locale #{@locale.inspect}. " \
          "Supported locales are: #{@supported}."
      end
    end
  end
end
