# frozen_string_literal: true

require_relative "ternary_function"
module Plurimath
  module Math
    module Function
      class Rule < TernaryFunction
        FUNCTION = {
          name: "rule",
          first_value: "first argument",
          second_value: "second argument",
          third_value: "third argument",
        }.freeze

        def to_asciimath(**)
          ""
        end

        def to_latex(options:)
          first_value = "[#{parameter_one.to_latex(options: options)}]" if parameter_one
          second_value = "{#{parameter_two.to_latex(options: options)}}" if parameter_two
          third_value = "{#{parameter_three.to_latex(options: options)}}" if parameter_three
          "\\rule#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag(intent, **)
          Utility.ox_element("mi")
        end

        def to_omml_without_math_tag(_, **)
          [Utility.ox_element("m:r") << Utility.ox_element("m:t")]
        end

        def to_html
          ""
        end

        def to_unicodemath(**)
          ""
        end
      end
    end
  end
end
