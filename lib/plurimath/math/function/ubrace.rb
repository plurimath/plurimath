# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Ubrace < BinaryFunction
        def to_asciimath
          first_value = "(#{parameter_one.to_asciimath})" if parameter_one
          "ubrace#{first_value}"
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\underbrace#{first_value}"
        end

        def to_mathml_without_math_tag
          mo_tag = (Utility.ox_element("mo") << "&#x23df;")
          return mo_tag unless parameter_one

          over_tag = Utility.ox_element("munder")
          over_tag.attributes.merge!(parameter_two) if parameter_two && !parameter_two.empty?
          Utility.update_nodes(
            over_tag,
            [
              parameter_one.to_mathml_without_math_tag,
              mo_tag,
            ],
          )
        end

        def tag_name
          "underover"
        end

        def omml_tag_name
          "undOvr"
        end

        def validate_function_formula
          false
        end

        def to_omml_without_math_tag(display_style)
          return r_element("⏟", rpr_tag: false) unless all_values_exist?

          symbol = Symbol.new("⏟")
          Underset.new(parameter_one, symbol).to_omml_without_math_tag(true)
        end
      end

      Underbrace = Ubrace
    end
  end
end
