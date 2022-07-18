# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Vmatrix < Table
          def initialize(parameter_one,
                         parameter_two = "|",
                         parameter_three = "|")
            parameter_three = nil if parameter_two == "norm["
            super
          end

          def to_latex
            first_value = parameter_one&.map(&:to_latex)&.join("\\\\")
            "\\begin{vmatrix}#{first_value}\\end{vmatrix}"
          end
        end
      end
    end
  end
end
