# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class Bold < FontStyle
          def initialize(parameter_one,
                         parameter_two = "bold")
            super
          end

          def to_asciimath
            "mathbf(#{parameter_one.to_asciimath})"
          end

          def to_latex
            first_value = parameter_one.to_latex if parameter_one
            "\\mathbf{#{first_value}}"
          end

          def to_mathml_without_math_tag
            Utility.update_nodes(
              Utility.ox_element(
                "mstyle",
                attributes: { mathvariant: "bold" },
              ),
              [parameter_one.to_mathml_without_math_tag],
            )
          end
        end
      end
    end
  end
end
