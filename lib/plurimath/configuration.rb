# frozen_string_literal: true

module Plurimath
  class Configuration
    DEFAULT_DECIMAL = "."

    # Cap on bounded sum/prod iterations, guarding the untrusted-document
    # evaluation path against runaway loops. Set to nil to disable the cap.
    DEFAULT_MAX_ITERATIONS = 100_000

    attr_accessor :number_formatter, :locale, :evaluation_max_iterations

    def initialize
      @evaluation_max_iterations = DEFAULT_MAX_ITERATIONS
    end

    def deprecation
      Deprecation
    end

    def decimal
      Formatter::SupportedLocales.decimal_for(locale, default: DEFAULT_DECIMAL)
    end
  end
end
