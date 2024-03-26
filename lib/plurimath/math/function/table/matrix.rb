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
            table_tag = Utility.update_nodes(
              ox_element("mtable", attributes: table_attribute),
              value&.map(&:to_mathml_without_math_tag)
            )
            return table_tag if table_tag_only?

            Utility.update_nodes(
              ox_element("mrow"),
              [mo_tag(open_paren), table_tag, mo_tag(close_paren)]
            )
          end

          def to_unicodemath
            first_value = value.map(&:to_unicodemath).join("@")
            "#{open_paren}■(#{first_value})#{close_paren}"
          end

          protected

          def mo_tag(paren)
            (ox_element("mo") << paren) unless validate_paren(paren)
          end

          def table_tag_only?
            (open_paren&.include?("(") && close_paren&.include?(")")) || !(open_paren && close_paren)
          end
        end
      end
    end
  end
end
