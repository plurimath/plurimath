# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Array < Table
          def initialize(value = [],
                         open_paren = "[",
                         close_paren = "]",
                         options = {})
            super
          end

          def to_latex
            "\\begin{array}#{array_args || '.'}#{latex_content}\\end{array}"
          end

          def to_mathml_without_math_tag
            Utility.update_nodes(
              ox_element("mtable", attributes: table_attribute),
              value&.map(&:to_mathml_without_math_tag),
            )
          end

          private

          def array_args
            args = []
            value.first.parameter_one.each do |td|
              args << if Utility.symbol_value(td.parameter_one.first, "|")
                        "|"
                      else
                        Utility::ALIGNMENT_LETTERS.invert[Hash(td.parameter_two)[:columnalign]]&.to_s
                      end
            end
            "{#{args.join}}" unless args.compact.empty?
          end
        end
      end
    end
  end
end
