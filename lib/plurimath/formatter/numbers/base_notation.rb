# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Applies base prefix/postfix notation after numeric digits have already
      # been rendered.
      class BaseNotation
        DEFAULT_PREFIXES = {
          2 => "0b",
          8 => "0o",
          10 => "",
          16 => "0x",
        }.freeze

        attr_reader :base

        def initialize(options)
          @options = options
          @base = @options.base
          validate_base!
        end

        def apply(string)
          rendered = upcase_hex? ? string.tr(Base::HEX_DIGITS, Base::HEX_DIGITS.upcase) : string
          return rendered if default?

          return "#{rendered}#{options.base_postfix}" if options.base_postfix?

          "#{base_prefix}#{rendered}"
        end

        def default?
          base == Base::DEFAULT_BASE
        end

        def self.supported?(base)
          DEFAULT_PREFIXES.key?(base)
        end

        private

        attr_reader :options

        def base_prefix
          return options.base_prefix if options.base_prefix?

          DEFAULT_PREFIXES[base]
        end

        def upcase_hex?
          base == 16 && options.hex_capital == true
        end

        def validate_base!
          return if self.class.supported?(base)

          raise UnsupportedBase.new(base, DEFAULT_PREFIXES)
        end
      end
    end
  end
end
