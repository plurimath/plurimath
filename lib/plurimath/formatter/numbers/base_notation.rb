# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class BaseNotation
        DEFAULT_PREFIXES = {
          2 => "0b",
          8 => "0o",
          10 => "",
          16 => "0x",
        }.freeze

        attr_reader :base

        def initialize(symbols)
          @symbols = symbols
          @base = symbols[:base] || Base::DEFAULT_BASE
          validate_base!
        end

        def apply(string)
          rendered = upcase_hex? ? string.tr(Base::HEX_DIGITS, Base::HEX_DIGITS.upcase) : string
          return rendered if default?

          return "#{rendered}#{symbols[:base_postfix]}" if symbols.key?(:base_postfix)

          "#{base_prefix}#{rendered}"
        end

        def default?
          base == Base::DEFAULT_BASE
        end

        def self.supported?(base)
          DEFAULT_PREFIXES.key?(base)
        end

        private

        attr_reader :symbols

        def base_prefix
          return symbols[:base_prefix].to_s if symbols.key?(:base_prefix)

          DEFAULT_PREFIXES[base]
        end

        def upcase_hex?
          base == 16 && symbols[:hex_capital] == true
        end

        def validate_base!
          return if self.class.supported?(base)

          raise UnsupportedBase.new(base, DEFAULT_PREFIXES)
        end
      end
    end
  end
end
