# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Hat < UnaryFunction
        def to_mathml_without_math_tag
          mover_tag    = Utility.ox_element("mover")
          first_value  = parameter_one&.to_mathml_without_math_tag
          second_value = (Utility.ox_element("mo") << "^")
          Utility.update_nodes(
            mover_tag,
            [
              first_value,
              second_value,
            ],
          )
        end

        def validate_function_formula
          false
        end
      end
    end
  end
end
