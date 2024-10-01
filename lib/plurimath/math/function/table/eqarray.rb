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

          def to_unicodemath(options:)
            unicode_value = value.map { |val| val.to_unicodemath(options: options) }.join("@")
            "#{open_paren&.to_unicodemath(options: options)}█(#{unicode_value})#{close_paren&.to_unicodemath(options: options)}"
          end

          def to_mathml_without_math_tag(intent, **)
            matrix = super
            set_table_intent(matrix) if intent
            matrix["intent"] = intent_names[:equations] if intent
            matrix
          end

          private

          def set_table_intent(tag)
            matrix = tag.nodes.find { |tag| tag.name == "mtable" }
            return unless matrix

            matrix["intent"] = intent_names[:cases]
          end
        end
      end
    end
  end
end
