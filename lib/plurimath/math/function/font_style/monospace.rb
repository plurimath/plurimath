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

          def to_asciimath
            "mathtt(#{parameter_one&.to_asciimath})"
          end

          def to_latex
            "\\mathtt{#{parameter_one&.to_latex}}"
          end

          def to_mathml_without_math_tag
            Utility.update_nodes(
              Utility.ox_element(
                "mstyle",
                attributes: { mathvariant: "monospace" },
              ),
              [parameter_one&.to_mathml_without_math_tag],
            )
          end
        end
      end
    end
  end
end
