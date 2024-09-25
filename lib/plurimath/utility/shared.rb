# frozen_string_literal: true

module Plurimath
  class Utility
    module Shared
      module Constants
        ALIGNMENT_LETTERS = {
          c: "center",
          r: "right",
          l: "left",
        }.freeze
      end

      module LatexAndMathml
        def table_separator(separator, value, symbol: "solid")
          sep_symbol = Math::Function::Td.new([Math::Symbols::Paren::Vert.new])
          separator&.each_with_index do |sep, ind|
            next unless sep == symbol

            value.each do |val|
              if ["solid", "|"].include?(symbol)
                index = symbol == "solid" ? (ind + 1) : ind
                val.parameter_one.insert(index, sep_symbol)
              end
              val.parameter_one.map! { |v| v.nil? ? Math::Function::Td.new([]) : v }
            end
          end
          value
        end
      end
    end
  end
end