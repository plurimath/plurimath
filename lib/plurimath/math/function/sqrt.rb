# frozen_string_literal: true

require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Sqrt < UnaryFunction
        include Mathml::Utility

        attr_accessor :options

        def to_mathml_without_math_tag(intent, options:)
          Utility.update_nodes(
            ox_element("msqrt"),
            Array(parameter_one&.to_mathml_without_math_tag(intent, options: options)),
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          rad_element = Utility.ox_element("rad", namespace: "m")
          pr_element = Utility.ox_element("radPr", namespace: "m")
          pr_element << Utility.ox_element(
            "degHide",
            namespace: "m",
            attributes: { "m:val": "on" },
          )
          Utility.update_nodes(
            rad_element,
            [
              (pr_element << Utility.pr_element("ctrl", true, namespace: "m")),
              Utility.ox_element("deg", namespace: "m"),
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
            ],
          )
          [rad_element]
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end

        def to_unicodemath(options:)
          "√#{unicodemath_parens(parameter_one, options: options)}"
        end
      end
    end
  end
end
