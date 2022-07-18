# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Split < Table
          def initialize(parameter_one,
                         parameter_two = "[",
                         parameter_three = "]")
            super
          end

          def to_latex
            first_value = parameter_one&.map(&:to_latex)&.join("\\\\")
            "\\begin{split}#{first_value}\\end{split}"
          end
        end
      end
    end
  end
end
