# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Bmatrix < Table
          def initialize(value,
                         open_paren = "[",
                         close_paren = "]",
                         options = {})
            super
          end

          def to_latex
            "\\begin#{opening}#{latex_content}\\end#{matrix_class}"
          end

          def to_mathml_without_math_tag
            table_tag = Utility.ox_element("mtable", attributes: table_attribute)
            Utility.update_nodes(
              table_tag,
              value&.map(&:to_mathml_without_math_tag),
            )
            Utility.update_nodes(
              Utility.ox_element("mrow"),
              [
                mo_element(mathml_parenthesis(open_paren)),
                table_tag,
                mo_element(mathml_parenthesis(close_paren)),
              ],
            )
          end
        end
      end
    end
  end
end
