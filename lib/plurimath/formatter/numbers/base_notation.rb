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
          rendered = if upcase_hex?
                       string.tr(Base::HEX_DIGITS,
                                 Base::HEX_DIGITS.upcase)
                     else
                       string
                     end
          return rendered if default?

          "#{base_prefix}#{rendered}#{base_postfix}"
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
          # A postfix without an explicit prefix opts out of the default prefix.
          return "" if options.base_postfix?

          DEFAULT_PREFIXES[base]
        end

        def base_postfix
          options.base_postfix.to_s
        end

        def upcase_hex?
          base == 16 && options.hex_capital == true
        end

        def validate_base!
          return if self.class.supported?(base)

          raise Plurimath::Errors::UnsupportedBase.new(base, DEFAULT_PREFIXES)
        end
      end
    end
  end
end
