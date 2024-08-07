# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Sup < UnaryFunction
        def to_mathml_without_math_tag(intent)
          mo_tag = ox_element("mo") << "sup"
          first_value = mathml_value(intent)
          first_value = mathml_value(intent)&.insert(0, mo_tag) unless hide_function_name
          Utility.update_nodes(
            ox_element("mrow"),
            first_value,
          )
        end

        def to_omml_without_math_tag(display_style)
          array = []
          array << r_element("sup", rpr_tag: false) unless hide_function_name
          array += Array(omml_value(display_style))
          array
        end
      end
    end
  end
end
