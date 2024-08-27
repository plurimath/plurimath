# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Eqarray < Table
          def initialize(value = [],
                         open_paren = "",
                         close_paren = "",
                         options = {})
            super
          end

          def to_unicodemath
            "#{open_paren&.to_unicodemath}█(#{value&.map(&:to_unicodemath).join("@")})#{close_paren&.to_unicodemath}"
          end

          def to_mathml_without_math_tag(intent, **)
            matrix = super
            set_table_intent(matrix) if intent
            matrix["intent"] = ":equations" if intent
            matrix
          end

          private

          def set_table_intent(tag)
            matrix = tag.nodes.find { |tag| tag.name == "mtable" }
            return unless matrix

            matrix["intent"] = ":cases"
          end
        end
      end
    end
  end
end
