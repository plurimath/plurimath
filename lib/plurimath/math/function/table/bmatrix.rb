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
            attributes = {
              open: mathml_parenthesis(open_paren),
              close: mathml_parenthesis(close_paren),
            }
            Utility.ox_element("mfenced", attributes: attributes) << table_tag
          end
        end
      end
    end
  end
end
