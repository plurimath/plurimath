# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ubrace < UnaryFunction
        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\underbrace#{first_value}"
        end

        def to_mathml_without_math_tag
          mo_tag = (Utility.ox_element("mo") << "&#x23df;")
          if parameter_one
            over_tag = Utility.ox_element("munder")
            arr_value = mathml_value
            Utility.update_nodes(over_tag, (arr_value << mo_tag))
          else
            mo_tag
          end
        end

        def tag_name
          "underover"
        end

        def validate_function_formula
          false
        end
      end

      Underbrace = Ubrace
    end
  end
end
