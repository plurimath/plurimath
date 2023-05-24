# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Dot < UnaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          dot_tag = (Utility.ox_element("mo") << ".")
          over_tag = Utility.ox_element("mover")
          Utility.update_nodes(
            over_tag,
            [
              first_value,
              dot_tag,
            ],
          )
        end
      end
    end
  end
end
