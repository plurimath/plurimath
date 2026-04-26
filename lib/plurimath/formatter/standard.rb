# frozen_string_literal: true

module Plurimath
  module Formatter
    class Standard < Plurimath::NumberFormatter
      attr_accessor :precision

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

      def initialize(locale: "en", string_format: nil, options: {},
precision: nil)
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
        unless options.key?(:fraction_group_digits)
          options[:fraction_group_digits] =
            default_options[:fraction_group_digits]
        end
        unless options.key?(:fraction_group)
          options[:fraction_group] =
            default_options[:fraction_group]
        end
        unless options.key?(:exponent_sign)
          options[:exponent_sign] =
            default_options[:exponent_sign]
        end
        unless options.key?(:group_digits)
          options[:group_digits] =
            default_options[:group_digits]
        end
        unless options.key?(:number_sign)
          options[:number_sign] =
            default_options[:number_sign]
        end
        unless options.key?(:significant)
          options[:significant] =
            default_options[:significant]
        end
        unless options.key?(:notation)
          options[:notation] =
            default_options[:notation]
        end
        unless options.key?(:decimal)
          options[:decimal] =
            default_options[:decimal]
        end
        options[:group] = default_options[:group] unless options.key?(:group)
        options[:times] = default_options[:times] unless options.key?(:times)
        options[:e] = default_options[:e] unless options.key?(:e)
        options
      end
    end
  end
end
