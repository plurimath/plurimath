# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Table
        class Multline < Table
          # --- Catalog documentation (see Plurimath::Documentation) ---
          DESCRIPTION = "Splits a single long equation across several lines."
          REFERENCE = "https://en.wikibooks.org/wiki/LaTeX/Advanced_Mathematics"
          EXAMPLE = -> { new([Tr.new([Td.new([sym("x")])])]) }
          # --- end catalog documentation ---

          def initialize(value,
                         open_paren = "[",
                         close_paren = "]",
                         options = {})
            super
          end

          def to_latex(options:)
            "\\begin#{opening}#{latex_content(options: options)}\\end#{matrix_class}"
          end
        end
      end
    end
  end
end
