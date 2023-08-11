# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class Normal < FontStyle
          def initialize(parameter_one,
                         parameter_two = "rm")
            super
          end

          def to_asciimath
            "rm(#{parameter_one&.to_asciimath})"
          end

          def to_latex
            "\\mathrm{#{parameter_one&.to_latex}}"
          end

          def to_mathml_without_math_tag
            Utility.update_nodes(
              Utility.ox_element(
                "mstyle",
                attributes: { mathvariant: "normal" },
              ),
              [parameter_one&.to_mathml_without_math_tag],
            )
          end

          def to_omml_without_math_tag(display_style)
            font_styles(display_style, sty: "p")
          end
        end
      end
    end
  end
end
