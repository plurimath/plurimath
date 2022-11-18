# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Over < BinaryFunction
        def to_asciimath
          first_value = parameter_one.to_asciimath if parameter_one
          second_value = parameter_two.to_asciimath if parameter_two
          "overset#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          mover_tag    = Utility.ox_element("mover")
          first_value  = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          Utility.update_nodes(
            mover_tag,
            [
              first_value,
              second_value,
            ],
          )
        end

        def to_latex
          first_value = parameter_one&.to_latex
          two_value = parameter_two&.to_latex
          "{#{first_value} \\over #{two_value}}"
        end
      end
    end
  end
end
