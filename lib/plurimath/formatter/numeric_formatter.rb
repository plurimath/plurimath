# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumericFormatter
      attr_accessor :locale, :localize_number, :localizer_symbols,
                    :twitter_cldr_reader

      def initialize(locale, localize_number:, localizer_symbols:)
        @locale = locale
        @localize_number = localize_number
        @localizer_symbols = localizer_symbols
        @base_symbols = symbol_resolver.resolve
        @twitter_cldr_reader = @base_symbols
      end

      def localized_number(number_string, locale:, precision:, format:)
        options = format_options(number_string, precision, format)
        @twitter_cldr_reader = options.to_h
        if Numbers::NotationRenderer.supported?(options.notation)
          return notation_renderer(options).render(number_string, options.notation)
        end

        render_localized_number(number_string, options)
      end

      private

      def symbol_resolver
        Numbers::SymbolResolver.new(
          locale,
          localizer_symbols: @localizer_symbols,
          localize_number: @localize_number,
        )
      end

      def symbols_for(format)
        @base_symbols.merge(format)
      end

      def render_localized_number(num, options)
        Formatter::NumberFormatter.new(
          BigDecimal(num),
          options,
        ).format
      end

      def notation_renderer(options)
        Numbers::NotationRenderer.new(options)
      end

      def format_options(number_string, precision, format)
        Numbers::FormatOptions.new(
          number_string,
          symbols: symbols_for(format),
          format: format,
          precision: precision,
          precision_resolver: precision_resolver,
        )
      end

      def precision_resolver
        @precision_resolver ||= Numbers::PrecisionResolver.new
      end
    end
  end
end
