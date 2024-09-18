# frozen_string_literal: true

require_relative "../number_formatter"
module Plurimath
  module Formatter
    class Standard < Plurimath::NumberFormatter
      attr_accessor :precision

      DEFAULT_OPTIONS = {
        fraction_group_digits: 3,
        exponent_sign: "plus",
        fraction_group: "'",
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

      def initialize(locale: "en", string_format: nil, options: {}, precision: nil)
        super(
          locale,
          localize_number: string_format,
          localizer_symbols: set_default_options(options),
          precision: precision,
        )
      end

      def set_default_options(options)
        default_options = self.class::DEFAULT_OPTIONS
        self.precision ||= default_options[:precision]
        options ||= default_options
        options[:fraction_group_digits] ||= default_options[:fraction_group_digits]
        options[:fraction_group] ||= default_options[:fraction_group]
        options[:exponent_sign] ||= default_options[:exponent_sign]
        options[:group_digits] ||= default_options[:group_digits]
        options[:significant] ||= default_options[:significant]
        options[:notation] ||= default_options[:notation]
        options[:decimal] ||= default_options[:decimal]
        options[:group] ||= default_options[:group]
        options[:times] ||= default_options[:times]
        options[:e] ||= default_options[:e]
        options
      end
    end
  end
end
