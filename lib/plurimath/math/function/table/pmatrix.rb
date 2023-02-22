# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Pmatrix < Table
          def initialize(value,
                         open_paren = "(",
                         close_paren = ")",
                         options = {})
            super
          end

          def to_latex
            "\\begin#{opening}#{latex_content}\\end#{matrix_class}"
          end
        end
      end
    end
  end
end
