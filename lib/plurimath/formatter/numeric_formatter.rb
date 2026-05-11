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
        @twitter_cldr_reader = symbols_for(format)
        if Numbers::NotationRenderer.supported?(options.notation)
          return notation_renderer(options).render(number_string, options.notation)
        end

        render_localized_number(number_string, options.precision)
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

      def render_localized_number(num, precision)
        Formatter::NumberFormatter.new(
          BigDecimal(num),
          @twitter_cldr_reader,
        ).format(
          precision: precision,
        )
      end

      def notation_renderer(options)
        Numbers::NotationRenderer.new(
          @twitter_cldr_reader,
          precision: options.precision,
          exponent_sign: options.exponent_sign,
          exponent_separator: options.exponent_separator,
          times: options.times,
        )
      end

      def format_options(number_string, precision, format)
        Numbers::FormatOptions.new(
          number_string,
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
