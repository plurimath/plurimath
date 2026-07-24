# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Table
        class Array < Table
          # --- Catalog documentation (see Plurimath::Documentation) ---
          DESCRIPTION = "Lays out entries in a matrix-like grid with per-column alignment."
          REFERENCE = "https://en.wikibooks.org/wiki/LaTeX/Mathematics"
          EXAMPLE = -> { new([Tr.new([Td.new([sym("x")])])]) }
          # --- end catalog documentation ---

          def initialize(value = [],
                         open_paren = "[",
                         close_paren = "]",
                         options = {})
            super
          end

          def to_latex(options:)
            "\\begin{array}#{array_args || '.'}#{latex_content(options: options)}\\end{array}"
          end

          def to_mathml_without_math_tag(intent, options:)
            XmlHelper.update_nodes(
              ox_element("mtable", attributes: attributes(intent)),
              value&.map do |object|
                object&.to_mathml_without_math_tag(intent, options: options)
              end,
            )
          end

          private

          def array_args
            args = value.first.parameter_one.map do |td|
              if Utility.symbol_value(td.parameter_one.first, "|")
                "|"
              else
                Utility::ALIGNMENT_LETTERS.invert[Hash(td.parameter_two)[:columnalign]]&.to_s
              end
            end
            "{#{args.join}}" unless args.compact.empty?
          end

          def attributes(intent)
            return table_attribute unless intent

            table_attribute.merge(intent: intent_names[:equations])
          end
        end
      end
    end
  end
end
