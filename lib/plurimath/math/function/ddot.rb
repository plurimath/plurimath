# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ddot < UnaryFunction
        def to_mathml_without_math_tag
          second_value = Utility.ox_element("mo") << ".."
          Utility.update_nodes(
            Utility.ox_element("mover", attributes: { accent: "true" }),
            mathml_value << second_value,
          )
        end
      end
    end
  end
end
