# frozen_string_literal: true

require_relative "ternary_function"
module Plurimath
  module Math
    module Function
      class Rule < TernaryFunction
        def to_asciimath
          ""
        end

        def to_latex
          first_value = "[#{parameter_one.to_latex}]" if parameter_one
          second_value = "{#{parameter_two.to_latex}}" if parameter_two
          third_value = "{#{parameter_three.to_latex}}" if parameter_three
          "\\rule#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag
          Utility.ox_element("mi")
        end

        def to_omml_without_math_tag(display_style)
          [Utility.ox_element("m:r") << Utility.ox_element("m:t")]
        end

        def to_html
          ""
        end
      end
    end
  end
end
