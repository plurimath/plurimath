# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Describes base prefix/postfix notation as a resolved value object.
      # Constructed from FormatOptions via .from_options; carries the resolved
      # prefix and postfix strings so renderers can decide how to represent the
      # base (inline text, MathML subscript, LaTeX subscript, etc.).
      class BaseNotation
        DEFAULT_PREFIXES = {
          2 => "0b",
          8 => "0o",
          10 => "",
          16 => "0x",
        }.freeze

        attr_reader :base, :prefix, :postfix, :hex_capital

        def initialize(base:, prefix: "", postfix: "", hex_capital: nil,
                       explicit_prefix: false, explicit_postfix: false)
          @base = base
          @prefix = prefix
          @postfix = postfix
          @hex_capital = hex_capital
          @explicit_prefix = explicit_prefix
          @explicit_postfix = explicit_postfix
        end

        def self.from_options(options)
          base = options.base
          validate!(base)

          new(
            base: base,
            prefix: resolve_prefix(options, base),
            postfix: options.base_postfix.to_s,
            hex_capital: options.hex_capital,
            explicit_prefix: options.base_prefix?,
            explicit_postfix: options.base_postfix?,
          )
        end

        def self.supported?(base)
          DEFAULT_PREFIXES.key?(base)
        end

        def default?
          base == Base::DEFAULT_BASE
        end

        # Caller overrode prefix or postfix at format-call time. Renderers that
        # honor semantic base notation (msub, \mathrm{}_{base}, _(base)) must
        # defer to the literal prefix/postfix in that case.
        def literal?
          !default? && (explicit_prefix? || explicit_postfix?)
        end

        def semantic?
          !default? && !literal?
        end

        def upcase_hex?
          base == 16 && hex_capital == true
        end

        def wrap(digits)
          "#{prefix}#{digits}#{postfix}"
        end

        private

        attr_reader :explicit_prefix, :explicit_postfix

        alias explicit_prefix? explicit_prefix
        alias explicit_postfix? explicit_postfix

        def self.resolve_prefix(options, base)
          return options.base_prefix if options.base_prefix?
          return "" if options.base_postfix?

          DEFAULT_PREFIXES[base]
        end
        private_class_method :resolve_prefix

        def self.validate!(base)
          return if supported?(base)

          raise Plurimath::Errors::UnsupportedBase.new(base, DEFAULT_PREFIXES)
        end
        private_class_method :validate!
      end
    end
  end
end
