# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class Script < FontStyle
          def initialize(parameter_one,
                         parameter_two = "script")
            super
          end

          def to_asciimath
            "mathcal(#{parameter_one&.to_asciimath})"
          end

          def to_latex
            "\\mathcal{#{parameter_one&.to_latex}}"
          end

          def to_mathml_without_math_tag(intent)
            Utility.update_nodes(
              Utility.ox_element(
                "mstyle",
                attributes: { mathvariant: "script" },
              ),
              [parameter_one&.to_mathml_without_math_tag(intent)],
            )
          end

          def to_omml_without_math_tag(display_style)
            font_styles(display_style, scr: "script")
          end
        end
      end
    end
  end
end
