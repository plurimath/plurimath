# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Table
        class Vmatrix < Table
          # --- Catalog documentation (see Plurimath::Documentation) ---
          DESCRIPTION = "A matrix enclosed in single vertical bars, denoting a determinant; its capitalized Vmatrix form uses double bars for a norm."
          REFERENCE = "https://en.wikipedia.org/wiki/Determinant"
          EXAMPLE = -> { new([Tr.new([Td.new([sym("x")])])]) }
          # --- end catalog documentation ---

          def initialize(value,
                         open_paren = "|",
                         close_paren = "|",
                         options = {})
            super
          end

          def to_latex(options:)
            "\\begin#{opening}#{latex_content(options: options)}\\end#{matrix_class}"
          end

          def to_unicodemath(options:)
            unicode_value = value.map do |val|
              val.to_unicodemath(options: options)
            end.join("@")
            "#{matrix_symbol}(#{unicode_value})"
          end

          def to_mathml_without_math_tag(intent, **)
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

          def intent_attr_value(_intent)
            intent_names[capital_vmatrix? ? :normed_matrix : :determinant]
          end
        end
      end
    end
  end
end
