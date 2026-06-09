# frozen_string_literal: true

module Plurimath
  module Formatter
    class Standard < Plurimath::NumberFormatter
      DEFAULT_OPTIONS = {
        fraction_group_digits: 3,
        exponent_sign: nil,
        fraction_group: "'",
        number_sign: nil,
        notation: :basic,
        group_digits: 3,
        significant: 0,
        digit_count: 0,
        precision: 0,
        decimal: ".",
        group: ",",
        times: "x",
        e: "e",
      }.freeze

      def initialize(
        locale: "en",
        string_format: nil,
        options: {},
        precision: nil
      )
        super(
          locale,
          localize_number: string_format,
          localizer_symbols: set_default_options(options),
          precision: precision,
        )
      end

      def set_default_options(options)
        options = options ? options.dup : {}
        apply_default_symbols(options)
        options
      end

      private

      def apply_default_symbols(options)
        %i[
          fraction_group_digits
          fraction_group
          exponent_sign
          group_digits
          number_sign
          significant
          notation
          decimal
          group
          times
          e
        ].each { |key| default_key(options, key) }
      end

      def default_key(options, key)
        options[key] = self.class::DEFAULT_OPTIONS[key] unless options.key?(key)
      end
    end
  end
end
