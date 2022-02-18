# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Overset
        attr_accessor :value, :symbol

        def initialize(value, symbol)
          @value = value
          @symbol = symbol
        end
      end
    end
  end
end
