# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Tilde < UnaryFunction
        def to_mathml_without_math_tag
          mover = Utility.ox_element("mover")
          first_value = (Utility.ox_element("mo") << "~")
          second_value = parameter_one.to_mathml_without_math_tag if parameter_one
          Utility.update_nodes(mover, [second_value, first_value])
        end
      end
    end
  end
end
