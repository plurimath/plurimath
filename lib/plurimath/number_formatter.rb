# frozen_string_literal: true

module Plurimath
  class NumberFormatter
    attr_accessor :locale, :precision, :localize_number, :localizer_symbols

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
      locale = supported_locale(locale)
      source = Formatter::Numbers::Source.new(number_string)
      options = format_options(source, locale, precision,
                               validated_format(format))

      if options.notation_supported?
        return notation_renderer(options).render(source, options.notation)
      end

      render_localized_number(source, options)
    end

    def twitter_cldr_reader(locale: @locale)
      symbols_for(supported_locale(locale), {})
    end

    private

    # localize_number/localizer_symbols are not per-option-hardened — they feed
    # SymbolResolver directly — so validate their types at the point of use (see
    # #symbol_resolver). That single check covers the constructor, the public
    # writers, and any later mutation, raising a clean ConfigurationError
    # instead of leaking a TypeError out of SymbolResolver.
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

    def supported_locale(locale)
      # Locale always falls back to :en for any unsupported value, including
      # nil and non-string/symbol types; it never raises.
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
  end
end
