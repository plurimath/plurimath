# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumberFormatter
      attr_reader :number, :data_reader

      def initialize(number, data_reader = {})
        @number = number
        @data_reader = data_reader
      end

      def format(precision: nil)
        data_reader[:precision] = precision || precision_from(number)
        integer_format, fraction_format, signif_format = *partition_tokens(number)
        return signif_format.apply(number.to_s("F"), integer_format, fraction_format) if significant?

        int, fraction = number.to_s("F").split(".")
        result = integer_format.apply(int, data_reader)
        result << fraction_format.apply(fraction, data_reader, int)
      end

      private

      def partition_tokens(number)
        [
          Numbers::Integer.new(
            number,
            data_reader,
          ),
          Numbers::Fraction.new(
            number,
            data_reader,
          ),
          Numbers::Significant.new(
            data_reader,
          )
        ]
      end

      def precision_from(number)
        return 0 if number.fix == number

        parts = number.to_s("F").split(".")
        parts.size == 2 ? parts[1].size : 0
      end

      def significant?
        data_reader[:significant] && !data_reader[:significant].zero?
      end
    end
  end
end
