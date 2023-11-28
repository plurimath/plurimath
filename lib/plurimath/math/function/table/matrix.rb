# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Matrix < Table
          def initialize(value = [],
                         open_paren = "(",
                         close_paren = ")",
                         options = {})
            super
          end

          def to_asciimath
            "{:#{value.map(&:to_asciimath).join(", ")}:}"
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
          end
        end
      end
    end
  end
end
