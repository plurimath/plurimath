# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Norm < UnaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          norm = Utility.omml_element("mo") << "&#x2225;"
          Utility.update_nodes(
            Utility.omml_element("mrow"),
            [
              norm,
              first_value,
              norm,
            ],
          )
        end
      end
    end
  end
end
