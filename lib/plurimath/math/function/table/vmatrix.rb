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
            "\\begin#{opening}#{latex_content}\\end#{ending}"
          end
        end
      end
    end
  end
end
