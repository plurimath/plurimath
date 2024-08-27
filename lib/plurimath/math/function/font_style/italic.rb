# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class Italic < FontStyle
          def initialize(parameter_one,
                         parameter_two = "italic")
            super
          end

          def to_asciimath
            "ii(#{parameter_one&.to_asciimath})"
          end

          def to_latex
            "\\mathit{#{parameter_one&.to_latex}}"
          end

          def to_mathml_without_math_tag(intent, options:)
            Utility.update_nodes(
              Utility.ox_element(
                "mstyle",
                attributes: { mathvariant: "italic" },
              ),
              [parameter_one&.to_mathml_without_math_tag(intent, options: options)],
            )
          end

          def to_omml_without_math_tag(display_style)
            font_styles(display_style, sty: "i")
          end
        end
      end
    end
  end
end
