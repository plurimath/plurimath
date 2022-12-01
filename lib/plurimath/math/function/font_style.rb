# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class FontStyle < BinaryFunction
        def to_asciimath
          "#{parameter_two}#{parameter_one.to_asciimath}"
        end

        def to_mathml_without_math_tag
          first_value = parameter_one.to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element(
              "mstyle",
              attributes: { mathvariant: parameter_two },
            ),
            [first_value],
          )
        end

        def to_html
          "<i>#{parameter_two}</i>#{parameter_one.to_html}"
        end

        def to_latex
          first_value = parameter_one.to_latex if parameter_one
          "\\#{parameter_two}{#{first_value}}"
        end
      end
    end
  end
end
