# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Abs < UnaryFunction
        def to_mathml_without_math_tag
          symbol = Utility.ox_element("mo") << "|"
          first_value = mathml_value&.insert(0, symbol)
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            first_value << symbol,
          )
        end
      end
    end
  end
end
