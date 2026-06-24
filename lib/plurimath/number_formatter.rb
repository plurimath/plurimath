# frozen_string_literal: true

module Plurimath
  class NumberFormatter
    attr_accessor :locale, :localize_number, :localizer_symbols, :precision

    def initialize(
      locale = "en",
      localize_number: nil,
      localizer_symbols: {},
      precision: nil
    )
      @locale = supported_locale(locale)
      @localize_number = localize_number
      @localizer_symbols = localizer_symbols
      @precision = precision
    end

    def localized_number(
      number_string,
      locale: @locale,
      precision: @precision,
      format: {}
    )
      result = formatted_number(
        number_string,
        locale: locale,
        precision: precision,
        format: format,
      )
      result.to_s
    end

    def formatted_number(
      number_string,
      locale: @locale,
      precision: @precision,
      format: {}
    )
      locale = supported_locale(locale)
      format = validated_format(format)
      base = format.fetch(:base, Formatter::Numbers::Base::DEFAULT_BASE)
      source = Formatter::Numbers::Source.new(number_string, base: base)
      options = format_options(source, locale, precision, format)

      if options.notation_supported?
        return notation_renderer(options).render(source, options.notation)
      end

      render_localized_number(source, options)
    end

    # Formula-aware entry point. Returns a FormattedNumber,
    # FormattedNotation, or String. Override in subclasses that need the
    # Formula/Number context for rendering decisions; the default delegates
    # to #formatted_number with the merged format hash.
    def format_number(_formula, number, format: {})
      formatted_number(number.value.to_s, format: format)
    end

    def twitter_cldr_reader(locale: @locale)
      symbols_for(supported_locale(locale), {})
    end

    private

    def format_options(source, locale, precision, format)
      Formatter::Numbers::FormatOptions.new(
        source,
        symbols: symbols_for(locale, format),
        precision: precision,
        precision_resolver: precision_resolver,
      )
    end

    def notation_renderer(options)
      Formatter::Numbers::NotationRenderer.new(options)
    end

    def precision_resolver
      @precision_resolver ||= Formatter::Numbers::PrecisionResolver.new
    end

    def render_localized_number(source, options)
      Formatter::Numbers::NumberRenderer.new(
        source,
        options,
      ).format
    end

    def symbol_resolver(locale)
      Formatter::Numbers::SymbolResolver.new(
        locale,
        localizer_symbols: validated_localizer_symbols(localizer_symbols),
        localize_number: validated_localize_number(localize_number),
      )
    end

    def symbols_for(locale, format)
      symbol_resolver(locale).resolve.merge(format)
    end

    # Locale always falls back to :en for any unsupported value, including
    # nil and non-string/symbol types; it never raises.
    def supported_locale(locale)
      return :en unless locale.is_a?(String) || locale.is_a?(Symbol)

      Formatter::SupportedLocales::LOCALES.key?(locale.to_sym) ? locale.to_sym : :en
    end

    def validated_format(format)
      return {} if format.nil?
      unless format.is_a?(Hash)
        raise Plurimath::ConfigurationError.new(
          :invalid_formatter_option,
          option: :format,
          value: format,
          supported: "a Hash of formatter options",
        )
      end

      format
    end

    def validated_localize_number(value)
      return value if value.nil? || value.is_a?(String)

      raise Plurimath::ConfigurationError.new(
        :invalid_formatter_option, option: :localize_number, value: value, supported: "a String"
      )
    end

    def validated_localizer_symbols(value)
      return {} if value.nil?
      return value if value.is_a?(Hash)

      raise Plurimath::ConfigurationError.new(
        :invalid_formatter_option, option: :localizer_symbols, value: value, supported: "a Hash"
      )
    end
  end
end
