# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Obrace < UnaryFunction
        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\overbrace#{first_value}"
        end

        def to_mathml_without_math_tag
          mo_tag = (Utility.ox_element("mo") << "&#x23de;")
          if parameter_one
            over_tag = Utility.ox_element("mover")
            arr_value = mathml_value
            Utility.update_nodes(over_tag, (arr_value << mo_tag))
          else
            mo_tag
          end
        end
      end

      Overbrace = Obrace
    end
  end
end
