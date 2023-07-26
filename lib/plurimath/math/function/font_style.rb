# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class FontStyle < BinaryFunction
        def to_asciimath
          parameter_one&.to_asciimath
        end

        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element(
              "mstyle",
              attributes: { mathvariant: parameter_two },
            ),
            [first_value],
          )
        end

        def to_omml_without_math_tag
          Array(parameter_one&.insert_t_tag)
        end

        def to_html
          parameter_one&.to_html
        end

        def to_latex
          parameter_one&.to_latex
        end

        def validate_function_formula
          true
        end
      end
    end
  end
end
