# frozen_string_literal: true

module Plurimath
  class Unitsml
    module Function
      class Prefix
        attr_accessor :id, :unit_name, :symbol, :base, :power

        def initialize(id, unit_name, symbol = {}, base, power)
          @id = id
          @base = base
          @power = power
          @symbol = symbol
          @unit_name = unit_name
        end
      end
    end
  end
end
