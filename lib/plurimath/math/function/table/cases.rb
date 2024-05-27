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

          def to_mathml_without_math_tag(intent)
            table_tag = super
            table_tag.attributes[:intent] = ":cases" if intent
            table_tag
          end
        end
      end
    end
  end
end
