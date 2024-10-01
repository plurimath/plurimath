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

          def to_unicodemath(options:)
            unicode_value = value.map { |val| val.to_unicodemath(options: options) }.join("@")
            "Ⓒ(#{unicode_value})"
          end

          def to_mathml_without_math_tag(intent, **)
            table_tag = super
            set_table_intent(table_tag) if intent
            table_tag.attributes["intent"] = intent_names[:equations] if intent
            table_tag
          end

          private

          def set_table_intent(tag)
            table = tag.nodes.find { |tag| tag.name == "mtable" }
            table["intent"] = intent_names[:cases]
          end
        end
      end
    end
  end
end
