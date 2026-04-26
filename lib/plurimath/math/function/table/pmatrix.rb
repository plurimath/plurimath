# frozen_string_literal: true

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

          def to_latex(options:)
            "\\begin#{opening}#{latex_content(options: options)}\\end#{matrix_class}"
          end

          def to_unicodemath(options:)
            unicode_value = value.map do |val|
              val.to_unicodemath(options: options)
            end.join("@")
            "⒨(#{unicode_value})"
          end

          def to_mathml_without_math_tag(intent, **)
            matrix = super
            matrix["intent"] = intent_names[:parenthesized_matrix] if intent
            matrix
          end
        end
      end
    end
  end
end
