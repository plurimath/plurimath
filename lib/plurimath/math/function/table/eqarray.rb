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
        end
      end
    end
  end
end
