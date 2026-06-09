# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Merges locale defaults, explicit symbols, and localize_number templates
      # into a fresh symbol hash for one formatter call.
      class SymbolResolver
        LOCALIZE_NUMBER_REGEX = %r{(?<group>[^#])?(?<groupdigits>#+0)(?<decimal>.)(?<fractdigits>#+)(?<fractgroup>[^#])?}

        def initialize(locale, localizer_symbols:, localize_number:)
          @locale = locale
          @localizer_symbols = localizer_symbols
          @localize_number = localize_number
        end

        def resolve
          locale_symbols
            .merge(localizer_symbols_hash)
            .merge(localize_number_symbols)
        end

        private

        attr_reader :locale, :localizer_symbols, :localize_number

        def locale_symbols
          Formatter::SupportedLocales::LOCALES[locale.to_sym].dup
        end

        def localizer_symbols_hash
          return {} unless localizer_symbols

          localizer_symbols.respond_to?(:to_h) ? localizer_symbols.to_h : localizer_symbols
        end

        def localize_number_symbols
          localize_number or return {}
          match = LOCALIZE_NUMBER_REGEX.match(localize_number) or return {}
          {
            decimal: match[:decimal],
            group_digits: match[:groupdigits].size,
            fraction_group_digits: match[:fractdigits].size,
            group: normalize_space(match[:group] || ""),
            fraction_group: normalize_space(match[:fractgroup] || ""),
          }.compact
        end

        def normalize_space(value)
          value == " " ? "\u00A0" : value
        end
      end
    end
  end
end
