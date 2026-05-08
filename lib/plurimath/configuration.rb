# frozen_string_literal: true

module Plurimath
  class Configuration
    attr_accessor :number_formatter

    def deprecation
      Deprecation
    end
  end
end
