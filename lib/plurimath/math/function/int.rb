# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Int < BinaryFunction
        def to_asciimath
          first_value = "_#{wrapped(parameter_one)}" if parameter_one
          second_value = "^#{wrapped(parameter_two)}" if parameter_two
          "int#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_#{latex_wrapped(parameter_one)}" if parameter_one
          second_value = "^#{latex_wrapped(parameter_two)}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          mrow_tag = Utility.ox_element("msubsup")
          mo_tag = Utility.ox_element("mo") << invert_unicode_symbols.to_s
          first_value = parameter_one&.to_mathml_without_math_tag if parameter_one
          second_value = parameter_two&.to_mathml_without_math_tag if parameter_two
          Utility.update_nodes(
            mrow_tag,
            [
              mo_tag,
              first_value,
              second_value,
            ],
          )
        end
      end
    end
  end
end
