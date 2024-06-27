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

          def to_mathml_without_math_tag(intent)
            matrix = super
            matrix["intent"] = intent_attr_value(intent) if intent
            matrix
          end

          private

          def matrix_symbol
            capital_vmatrix? ? "⒩" : "⒱"
          end

          def capital_vmatrix?
            open_paren&.class_name == "norm"
          end

          def intent_attr_value(intent)
            capital_vmatrix? ? ":normed-matrix" : ":determinant"
          end
        end
      end
    end
  end
end
