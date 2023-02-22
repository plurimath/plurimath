# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Vec < UnaryFunction
        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element("mover"),
            [
              first_value,
              Utility.ox_element("mo") << "&#x2192;",
            ],
          )
        end
      end
    end
  end
end
