# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class Monospace < FontStyle
          def initialize(parameter_one,
                         parameter_two = "monospace")
            super
          end

          def to_asciimath(options:)
            "mathtt(#{parameter_one&.to_asciimath(options: options)})"
          end

          def to_latex(options:)
            "\\mathtt{#{parameter_one&.to_latex(options: options)}}"
          end

          def to_mathml_without_math_tag(intent, options:)
            Utility.update_nodes(
              Utility.ox_element(
                "mstyle",
                attributes: { mathvariant: "monospace" },
              ),
              [parameter_one&.to_mathml_without_math_tag(intent, options: options)],
            )
          end

          def to_omml_without_math_tag(display_style, options:)
            font_styles(display_style, sty: nil, scr: "monospace", options: options)
          end

          def to_unicodemath(options:)
            "ￗ#{unicodemath_parens(parameter_one, options: options)}"
          end
        end
      end
    end
  end
end
