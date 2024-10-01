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

          def to_latex(options:)
            "\\begin#{opening}#{latex_content(options: options)}\\end#{matrix_class}"
          end

          def to_mathml_without_math_tag(intent, options:)
            table_tag = ox_element("mtable", attributes: table_attribute)
            table_tag["intent"] = ":matrix(#{value.length},#{td_count})" if intent
            Utility.update_nodes(
              table_tag,
              value&.map { |object| object&.to_mathml_without_math_tag(intent, options: options) },
            )
            Utility.update_nodes(
              ox_element("mrow", attributes: intent_attr(intent)),
              [
                mo_element(mathml_parenthesis(open_paren, intent, options: options)),
                table_tag,
                mo_element(mathml_parenthesis(close_paren, intent, options: options)),
              ],
            )
          end

          def to_unicodemath(options:)
            unicode_value = value.map { |val| val.to_unicodemath(options: options) }.join("@")
            "#{matrix_symbol}(#{unicode_value})"
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
              intent: intent_names.dig(capital_bmatrix? ? :curly_braced_matrix : :bracketed_matrix)
            }
          end
        end
      end
    end
  end
end
