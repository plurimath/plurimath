# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Bmatrix < Table
          def initialize(parameter_one,
                         parameter_two = "[",
                         parameter_three = "]")
            super
          end

          def to_latex
            first_value = parameter_one&.map(&:to_latex)&.join("\\\\")
            matrices    = Latex::Constants::MATRICES.invert
            environment = matrices[parameter_two].to_s
            "\\begin{#{environment}}#{first_value}\\end{#{environment}}"
          end
        end
      end
    end
  end
end
