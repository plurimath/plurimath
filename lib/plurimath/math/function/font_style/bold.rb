# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class FontStyle
        class Bold < FontStyle
          # --- Catalog documentation (see Plurimath::Documentation) ---
          DESCRIPTION = "Renders its argument in a bold font."
          REFERENCE = "https://en.wikipedia.org/wiki/Mathematical_Alphanumeric_Symbols"
          EXAMPLE = -> { new(sym("x")) }
          # --- end catalog documentation ---

          def initialize(parameter_one,
                         parameter_two = "bold")
            super
          end

          def to_asciimath(options:)
            "mathbf(#{parameter_one&.to_asciimath(options: options)})"
          end

          def to_latex(options:)
            "\\mathbf{#{parameter_one&.to_latex(options: options)}}"
          end

          def to_mathml_without_math_tag(intent, options:)
            XmlHelper.update_nodes(
              XmlHelper.ox_element(
                "mstyle",
                attributes: { mathvariant: "bold" },
              ),
              [parameter_one&.to_mathml_without_math_tag(intent,
                                                         options: options)],
            )
          end

          def to_omml_without_math_tag(display_style, options:)
            font_styles(display_style, sty: "b", options: options)
          end
        end
      end
    end
  end
end
