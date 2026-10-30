# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sqrt < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "The square root of a radicand."
        REFERENCE = "https://en.wikipedia.org/wiki/Square_root"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        attr_accessor :options

        def to_mathml_without_math_tag(intent, options:)
          XmlHelper.update_nodes(
            ox_element("msqrt"),
            Array(parameter_one&.to_mathml_without_math_tag(intent,
                                                            options: options)),
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          rad_element = XmlHelper.ox_element("rad", namespace: "m")
          pr_element = XmlHelper.ox_element("radPr", namespace: "m")
          pr_element << XmlHelper.ox_element(
            "degHide",
            namespace: "m",
            attributes: { "m:val": "on" },
          )
          XmlHelper.update_nodes(
            rad_element,
            [
              (pr_element << XmlHelper.pr_element("ctrl", true, namespace: "m")),
              XmlHelper.ox_element("deg", namespace: "m"),
              omml_parameter(parameter_one, display_style, tag_name: "e",
                                                           options: options),
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

        def evaluate(evaluator)
          ::Math.sqrt(evaluator.evaluate_node(parameter_one))
        end
      end
    end
  end
end
