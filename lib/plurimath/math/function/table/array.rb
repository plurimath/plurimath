# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Array < Table
          def initialize(parameter_one = [],
                         parameter_two = "[",
                         parameter_three = "]")
            super
          end

          def to_latex
            divider = parameter_three&.map(&:to_latex)&.join
            "\\begin{array}{#{divider}}#{latex_content}\\end{array}"
          end
        end
      end
    end
  end
end
