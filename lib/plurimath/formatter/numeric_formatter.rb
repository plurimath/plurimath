# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumericFormatter
      attr_accessor :locale, :localize_number, :localizer_symbols,
                    :twitter_cldr_reader

      SUPPORTED_NOTATIONS = Numbers::NotationRenderer::SUPPORTED_NOTATIONS

      def initialize(locale, localize_number:, localizer_symbols:)
        @locale = locale
        @localize_number = localize_number
        @localizer_symbols = localizer_symbols
        @base_symbols = symbol_resolver.resolve
        @twitter_cldr_reader = @base_symbols
      end

      def localized_number(number_string, locale:, precision:, format:)
        options_instance_variables(number_string, format, precision)
        @twitter_cldr_reader = @base_symbols.merge(format)
        if SUPPORTED_NOTATIONS.include?(@notation&.to_sym)
          return notation_renderer.render(number_string, @notation)
        end

        localize_number(number_string)
      end

      private

      def symbol_resolver
        Numbers::SymbolResolver.new(
          locale,
          localizer_symbols: @localizer_symbols,
          localize_number: @localize_number,
        )
      end

      def localize_number(num)
        Formatter::NumberFormatter.new(
          BigDecimal(num),
          @twitter_cldr_reader,
        ).format(
          precision: @precision,
        )
      end

      def notation_renderer
        Numbers::NotationRenderer.new(
          @twitter_cldr_reader,
          precision: @precision,
          exponent_sign: @exponent_sign,
          exponent_separator: @e,
          times: @times,
        )
      end

      def options_instance_variables(string, format, precision)
        @e = format[:e]&.to_sym || :e
        @times = format[:times]&.to_sym || "\u{d7}"
        @notation = format[:notation]&.to_sym || nil
        @precision = precision_resolver.resolve(
          string,
          precision: precision,
          format: format,
          notation: @notation,
        )
        @exponent_sign = format[:exponent_sign]&.to_sym || nil
      end

      def precision_resolver
        @precision_resolver ||= Numbers::PrecisionResolver.new
      end
    end
  end
end
