# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Vmatrix < Table
          def initialize(value,
                         open_paren = "|",
                         close_paren = "|",
                         options = {})
            super
          end

          def to_latex
            "\\begin#{opening}#{latex_content}\\end#{matrix_class}"
          end

          def to_unicodemath
            "#{matrix_symbol}(#{value.map(&:to_unicodemath).join("@")})"
          end

          private

          def matrix_symbol
            open_paren == "norm[" ? "⒩" : "⒱"
          end
        end
      end
    end
  end
end
