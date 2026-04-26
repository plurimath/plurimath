# frozen_string_literal: true

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

          def to_asciimath(options:)
            ascii_value = value.map do |v|
              v.to_asciimath(options: options)
            end.join(", ")
            "{:#{ascii_value}:}"
          end

          def to_latex(options:)
            "\\begin#{opening}#{latex_content(options: options)}\\end#{matrix_class}"
          end

          def to_mathml_without_math_tag(intent, options:)
            table_tag = Utility.update_nodes(
              ox_element("mtable", attributes: table_attribute),
              value&.map do |object|
                object&.to_mathml_without_math_tag(intent, options: options)
              end,
            )
            return table_tag if table_tag_only?

            Utility.update_nodes(
              ox_element("mrow"),
              [mo_tag(open_paren), table_tag, mo_tag(close_paren)],
            )
          end

          def to_unicodemath(options:)
            first_value = value.map do |v|
              v.to_unicodemath(options: options)
            end.join("@")
            "#{open_paren&.to_unicodemath(options: options)}■(#{first_value})#{close_paren&.to_unicodemath(options: options)}"
          end

          protected

          def mo_tag(paren)
            (ox_element("mo") << paren) unless validate_paren(paren)
          end

          def table_tag_only?
            (open_paren&.class_name == "lround" && close_paren&.class_name == "rround") ||
              !(open_paren && close_paren)
          end
        end
      end
    end
  end
end
