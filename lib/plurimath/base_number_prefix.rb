# frozen_string_literal: true

module Plurimath
  # Shared base-prefix number literal rules (0x, 0b, 0o) for all Parslet
  # parsers and transforms. Including the Parser sub-module adds hex/binary/
  # octal parser atoms; including the Transform sub-module adds the
  # corresponding Math::Number construction rules. Define base prefixes here
  # once — every format parser picks them up automatically.
  module BaseNumberPrefix
    # Adds Parslet parser rules for hex/binary/octal prefixed literals.
    # Include in any Parslet::Parser subclass.
    module Parser
      def self.included(base)
        base.class_eval do
          rule(:hex_number) do
            (str("0x") | str("0X")) >> match["0-9a-fA-F"].repeat(1).as(:hex_number)
          end

          rule(:binary_number) do
            (str("0b") | str("0B")) >> match["01"].repeat(1).as(:binary_number)
          end

          rule(:octal_number) do
            (str("0o") | str("0O")) >> match["0-7"].repeat(1).as(:octal_number)
          end
        end
      end
    end

    # Adds Parslet transform rules that build Math::Number with the correct
    # base attribute from hex/binary/octal parse tree nodes.
    # Include in any Parslet::Transform subclass.
    module Transform
      def self.included(base)
        base.class_eval do
          rule(hex_number: simple(:hex)) { Math::Number.new(hex.to_s, base: 16) }
          rule(binary_number: simple(:bin)) { Math::Number.new(bin.to_s.to_i(2).to_s, base: 2) }
          rule(octal_number: simple(:oct)) { Math::Number.new(oct.to_s.to_i(8).to_s, base: 8) }
        end
      end
    end
  end
end
