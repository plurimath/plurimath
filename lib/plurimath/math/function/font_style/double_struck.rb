# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class DoubleStruck < FontStyle
          def initialize(parameter_one,
                         parameter_two = "double-struck")
            super
          end

          def to_asciimath
            "mathbb(#{parameter_one&.to_asciimath})"
          end

          def to_latex
            "\\mathbb{#{parameter_one&.to_latex}}"
          end

          def to_mathml_without_math_tag
            Utility.update_nodes(
              Utility.ox_element(
                "mstyle",
                attributes: { mathvariant: "double-struck" },
              ),
              [parameter_one&.to_mathml_without_math_tag],
            )
          end
        end
      end
    end
  end
end
