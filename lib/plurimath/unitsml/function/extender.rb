# frozen_string_literal: true

module Plurimath
  class Unitsml
    module Function
      class Extender
        attr_accessor :symbol

        def initialize(symbol)
          @symbol = symbol
        end
      end
    end
  end
end
