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

          def to_mathml_without_math_tag(intent)
            table_tag = ox_element("mtable", attributes: table_attribute)
            table_tag["intent"] = ":matrix(#{value.length},#{td_count})" if intent
            Utility.update_nodes(
              table_tag,
              value&.map { |object| object&.to_mathml_without_math_tag(intent) },
            )
            Utility.update_nodes(
              ox_element("mrow", attributes: intent_attr(intent)),
              [
                mo_element(mathml_parenthesis(open_paren, intent)),
                table_tag,
                mo_element(mathml_parenthesis(close_paren, intent)),
              ],
            )
          end

          def to_unicodemath
            "#{matrix_symbol}(#{value.map(&:to_unicodemath).join("@")})"
          end

          private

          def matrix_symbol
            capital_bmatrix? ? "Ⓢ" : "ⓢ"
          end

          def capital_bmatrix?
            open_paren.is_a?(Math::Symbols::Paren::Lcurly)
          end

          def intent_attr(intent)
            return {} unless intent

            {
              intent: capital_bmatrix? ? ":curly-braced-matrix" : ":bracketed-matrix"
            }
          end
        end
      end
    end
  end
end
