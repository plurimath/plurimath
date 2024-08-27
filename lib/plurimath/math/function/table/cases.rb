# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Cases < Table
          def initialize(value = [],
                         open_paren = "{",
                         close_paren = ":}",
                         options = {})
            super
          end

          def to_unicodemath
            "Ⓒ(#{value.map(&:to_unicodemath).join("@")})"
          end

          def to_mathml_without_math_tag(intent, **)
            table_tag = super
            set_table_intent(table_tag) if intent
            table_tag.attributes["intent"] = ":equations" if intent
            table_tag
          end

          private

          def set_table_intent(tag)
            table = tag.nodes.find { |tag| tag.name == "mtable" }
            table["intent"] = ":cases"
          end
        end
      end
    end
  end
end
