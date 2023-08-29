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

        def to_omml_without_math_tag(display_style)
          font_styles(display_style)
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

        def extract_class_from_text
          parameter_one.parameter_one if parameter_one.is_a?(Text)
          parameter_one.class_name
        end

        def extractable?
          parameter_one.is_a?(Text)
        end

        def font_styles(display_style, sty: "p", scr: nil)
          r_tag   = Utility.ox_element("r", namespace: "m")
          rpr_tag = Utility.ox_element("rPr", namespace: "m")
          fonts   = []
          fonts << Utility.ox_element("scr", namespace: "m", attributes: { "m:val": scr }) if scr
          fonts << Utility.ox_element("sty", namespace: "m", attributes: { "m:val": sty }) if sty
          r_tag << Utility.update_nodes(rpr_tag, fonts)
          Utility.update_nodes(
            r_tag,
            Array(parameter_one.font_style_t_tag(display_style)),
          )
        end
      end
    end
  end
end
