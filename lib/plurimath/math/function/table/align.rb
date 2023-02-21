# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Align < Table
          def initialize(parameter_one,
                         parameter_two = "[",
                         parameter_three = "]")
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
