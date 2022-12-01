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
            "mathbf#{wrapped(parameter_one)}"
          end

          def to_latex
            "\\mathbf{#{super}}"
          end
        end
      end
    end
  end
end
