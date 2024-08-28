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

          def to_asciimath(options:)
            "ii(#{parameter_one&.to_asciimath(options: options)})"
          end

          def to_latex(options:)
            "\\mathit{#{parameter_one&.to_latex(options: options)}}"
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

          def to_omml_without_math_tag(display_style, options:)
            font_styles(display_style, sty: "i", options: options)
          end
        end
      end
    end
  end
end
