# frozen_string_literal: true

module Plurimath
  module Math
    autoload :Core, "#{__dir__}/math/core"
    autoload :Formula, "#{__dir__}/math/formula"
    autoload :Function, "#{__dir__}/math/function"
    autoload :InvalidTypeError, "#{__dir__}/errors/invalid_type_error"
    autoload :Number, "#{__dir__}/math/number"
    autoload :ParseOptionError, "#{__dir__}/errors/parse_option_error"
    autoload :ParseError, "#{__dir__}/errors/parse_error"
    autoload :Symbols, "#{__dir__}/math/symbols"

    VALID_TYPES = {
      omml: Omml,
      html: Html,
      latex: Latex,
      mathml: Mathml,
      unitsml: Unitsml,
      unicode: UnicodeMath,
      asciimath: Asciimath,
    }.freeze
    SUPPORTED_PARSE_OPTIONS = %i[locale].freeze
    LOCALIZED_PARSE_TYPES = %i[asciimath html latex unicode].freeze

    module_function

    def parse(text, type, **options)
      raise InvalidTypeError.new unless valid_type?(type)

      type = type.to_sym
      unknown_options = options.keys - SUPPORTED_PARSE_OPTIONS
      raise_unknown_parse_options!(unknown_options) unless unknown_options.empty?

      raise_unsupported_parse_option!(type, :locale) if options.key?(:locale) && !localized_parse_type?(type)
      options = normalize_parse_options(options)

      begin
        parse_with_configuration(text, type, options)
      rescue ParseError
        # Re-raise ParseError from lower layers unchanged to preserve specialized error types
        raise
      rescue StandardError
        raise ParseError.new(text, type), cause: nil
      end
    end

    def parse_with_configuration(text, type, options)
      return parse_formula(text, type) unless options.key?(:locale)

      Plurimath.with_configuration do |config|
        config.locale = options.fetch(:locale)
        parse_formula(text, type)
      end
    end

    def parse_formula(text, type)
      klass = klass_from_type(type)
      formula = klass.new(text).to_formula
      formula.input_string = text
      formula
    end

    def klass_from_type(type_string_or_sym)
      VALID_TYPES[type_string_or_sym.to_sym]
    end

    def normalize_parse_options(options)
      return options unless options.key?(:locale)

      options.merge(
        locale: Formatter::SupportedLocales.key_for!(options.fetch(:locale)),
      )
    end

    def localized_parse_type?(type)
      LOCALIZED_PARSE_TYPES.include?(type)
    end

    def raise_unknown_parse_options!(options)
      raise ParseOptionError.unknown_options(
        options,
        supported_options: SUPPORTED_PARSE_OPTIONS,
      )
    end

    def raise_unsupported_parse_option!(type, option)
      raise ParseOptionError.unsupported_options(
        type,
        [option],
        supported_types: LOCALIZED_PARSE_TYPES,
      )
    end

    def valid_type?(type)
      (type.is_a?(::Symbol) || type.is_a?(String)) &&
        VALID_TYPES.key?(type.to_sym)
    end
  end
end
